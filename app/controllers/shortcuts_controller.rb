class ShortcutsController < ApplicationController
  before_action :hide_header, except: %i[ index index_lazy show ]
  before_action :authenticate_user!, except: %i[ index index_lazy show ogp ]
  before_action :ensure_user, only: %i[ edit update ]
  helper_method :prepare_meta_tags

  def index
  end

  def index_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @latest_shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc).page(params[:page])
    @popular_shortcuts = Shortcut.includes(:user).where(status: :published).select("shortcuts.*,
        COALESCE(view_count, 0) + COALESCE((SELECT COUNT(*) FROM bookmarks WHERE bookmarks.shortcut_id = shortcuts.id), 0) * 10 + COALESCE((SELECT COUNT(*) FROM favorites WHERE favorites.shortcut_id = shortcuts.id), 0) * 5 AS total_count").order("total_count DESC").limit(10)
  end

  def show
    @comment = Comment.new
    @shortcut = Shortcut.find(params[:id])
    if @shortcut.status != "published"
      redirect_to shortcuts_path
    end
    @shortcut.increment!(:view_count)
    @comments = @shortcut.comments.includes(:user).where(parent_id: nil).order(created_at: :asc)
    prepare_meta_tags(@shortcut)
  end

  def new
    @shortcut = Shortcut.new
  end

  def create
    unless current_user.confirmed?
      if current_user.shortcuts.present? && current_user.shortcuts.count >= 1
        redirect_to root_path, alert: "メールアドレスを認証してください"
        return
      end
    end
    @shortcut = current_user.shortcuts.build(shortcut_new_params)
    if @shortcut.save
      flash[:notice] = t("defaults.flash_message.created")
      redirect_to edit_shortcut_path(@shortcut)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    original_status = @shortcut.status
    @shortcut.assign_attributes(shortcut_update_params)
    @shortcut.tags = params.dig(:shortcut, :tag_names).split(",").uniq.map { |name| Tag.find_or_initialize_by(name: name.strip) }
    if @shortcut.save
      if params[:shortcut][:instructions].present?
        if @shortcut.instructions.present?
          @shortcut.instructions.destroy_all
        end
        params[:shortcut][:instructions].each_with_index do | instruction, index |
          @shortcut.instructions.create(step_number: index + 1, content: instruction)
        end
      end
      if params[:shortcut][:thumbnail_data].present?
        @shortcut.thumbnail.purge if @shortcut.thumbnail.attached?
        image_data = params[:shortcut][:thumbnail_data]
        content_type, _encoding, _string = image_data.split(/[:;,]/)[1..3]
        decoded_image = Base64.decode64(image_data.split(",")[1])
        file = Tempfile.new([ "thumbnail", ".png" ])
        file.binmode
        file.write(decoded_image)
        file.rewind
        @shortcut.thumbnail.attach(io: file, filename: "thumbnail.png", content_type: content_type)
      end
      if params[:shortcut][:status] == "published"
        flash[:notice] = "投稿を公開しました"
        GenerateOgpImageJob.perform_later(@shortcut.id) if @shortcut.needs_ogp_update?
      else
        flash[:notice] = "下書きを保存しました"
      end
      redirect_to mypage_path
    else
      @shortcut.status = original_status
      flash.now[:alert] = "エラーが発生しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shortcut = current_user.shortcuts.find(params[:id])
    @shortcut.destroy!
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "削除しました" }
    end
  end

  def archived
    @shortcut = current_user.shortcuts.find(params[:id])
    @shortcut.status = "archived"
    if @shortcut.save
      redirect_to mypage_path, notice: "非公開にしました"
    else
      redirect_to mypage_path, alert: "エラーが発生しました"
    end
  end

  def search
    @tags = Tag.where("name LIKE ?", "%#{params[:query]}").order(created_at: :desc).pluck(:name)
    render json: @tags
  end

  def generate_thumbnail
    unless current_user.confirmed?
      render json: {
        error: "画像を生成するにはメール認証を完了してください。"
      }, status: :unauthorized
      return
    end
    unless current_user.credits >= 100
      render json: {
        error: "残高が不足しています"
      }, status: :forbidden
      return
    end
    begin
      prompt = generate_prompt(params[:shortcut_title])
      image_base64 = OpenaiImageGenerator.new(prompt).generate_image
      image_bytes = Base64.decode64(image_base64)
      shortcut = Shortcut.find(params[:shortcut_id])
      shortcut.thumbnail.attach(io: StringIO.new(image_bytes), filename: "thumbnail_#{params[:shortcut_id]}.png", content_type: "image/png")
      shortcut.assign_attributes(title: params[:shortcut_title])
      shortcut.save!
      current_user.decrement!(:credits, 100)
      render json: {
        image_url: url_for(shortcut.thumbnail),
        remaining_credits: current_user.credits
      }
    rescue StandardError => e
      Rails.logger.error("画像生成エラー：#{e.message}")
      render json: { error: "画像生成に失敗しました：#{e.message}" }, status: :internal_server_error
    end
  end

  def download
    shortcut = Shortcut.find(params[:id])
    if shortcut.user === current_user
      redirect_to shortcut.download_url, allow_other_host: true
    elsif current_user.credits >= 1
      current_user.decrement!(:credits)
      redirect_to shortcut.download_url, allow_other_host: true
    else
      redirect_back fallback_location: shortcut_path(shortcut), alert: "ダウンロードの上限に達してます"
    end
  end

  def ogp
    shortcut = Shortcut.find(params[:id])
    title = shortcut.title
    thumbnail = shortcut.thumbnail.attached? ? shortcut.thumbnail : nil
    image = OgpCreator.build(title: title, thumbnail_attachment: thumbnail)
    send_data image.read, type: "image/png", disposition: "inline", filename: "ogp.png", stream: "true", status: 200, content_disposition: "inline", cache_control: "public, max-age=31536000"
  end

  private

  def generate_prompt(title)
    <<~PROMPT
      Create a vertically-oriented thumbnail image that explains an iPhone Shortcut, based on the title provided.
      - The image should clearly communicate what the Shortcut does, just by looking at it
      - Use bold and outlined, readable Japanese text in large font
      - Include relevant icons or illustrations
      - Use a flat, friendly, modern style with clear visual hierarchy
      - Background and text colors should be randomly selected but must maintain high contrast and good visibility
      - Avoid any unrelated decorations or confusing elements
      - Shortcut title:「#{title}」
    PROMPT
  end

  def shortcut_new_params
    params.require(:shortcut).permit(:title)
  end

  def shortcut_update_params
    params.require(:shortcut).permit(:title, :description, :download_url, :status, :instructions)
  end

  def prepare_meta_tags(shortcut)
    image_url = shortcut.ogp_image.attached? ? "#{url_for(shortcut.ogp_image)}?v=#{shortcut.updated_at.to_i}" : ActionController::Base.helpers.asset_url("ogp.png", host: request.base_url)
    set_meta_tags og: {
      site_name: "Shortcut Hub（ショートカットハブ）",
      title: shortcut.title,
      description: shortcut.description,
      type: "website",
      url: request.original_url,
      image: image_url,
      locale: "ja_JP"
    },
    twitter: {
      card: "summary_large_image",
      image: image_url
    }
  end

  def ensure_user
    @shortcut = Shortcut.find(params[:id])
    if @shortcut.user != current_user
      redirect_to shortcut_path(@shortcut)
    end
  end

  def hide_header
    @show_header = false
  end
end
