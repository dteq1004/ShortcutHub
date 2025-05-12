class ShortcutsController < ApplicationController
  before_action :hide_header, except: [:index, :index_lazy, :show]
  before_action :authenticate_user!, except: [:index, :index_lazy, :show]
  before_action :ensure_user, only: [:edit, :update]

  def index
  end

  def index_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @latest_shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc).page(params[:page])
    @popular_shortcuts = Shortcut
      .includes(:user)
      .where(status: :published)
      .select('shortcuts.*,
        COALESCE(view_count, 0) + COALESCE((SELECT COUNT(*) FROM bookmarks WHERE bookmarks.shortcut_id = shortcuts.id), 0) * 10 + COALESCE((SELECT COUNT(*) FROM favorites WHERE favorites.shortcut_id = shortcuts.id), 0) * 5 AS total_count')
      .order('total_count DESC')
      .limit(10)
  end

  def show
    @comment = Comment.new
    @shortcut = Shortcut.find(params[:id])
    if @shortcut.status != "published"
      redirect_to shortcuts_path
    end
    @shortcut.increment!(:view_count)
    @comments = @shortcut.comments.includes(:user).where(parent_id: nil).order(created_at: :asc)
  end

  def new
    @shortcut = Shortcut.new
  end

  def create
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
      if params[:shortcut][:status] == "published"
        flash[:notice] = "投稿を公開しました"
      else
        flash[:notice] = "下書きを保存しました"
      end
      redirect_to user_path(current_user)
    else
      flash[:alert] = "エラーが発生しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shortcut = current_user.shortcuts.find(params[:id])
    @shortcut.destroy!
  end

  def archived
    @shortcut = current_user.shortcuts.find(params[:id])
    @shortcut.status = "archived"
    if @shortcut.save
      render turbo_stream: turbo_stream.replace("shortcut-#{@shortcut.id}", partial: "users/shortcut", locals: { shortcut: @shortcut } )
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
    unless current_user.can_generate_thumbnail_this_month?
      render json: {
        error: "今月はすでに生成済みです。次回は#{current_user.next_generate_date}以降に生成できます。"
      }, status: :forbidden
      return
    end
    prompt = generate_prompt(params[:shortcut_title])
    image_base64 = OpenaiImageGenerator.new(prompt).generate_image
    image_bytes = Base64.decode64(image_base64)
    shortcut = Shortcut.find(params[:shortcut_id])
    shortcut.thumbnail.attach(io: StringIO.new(image_bytes), filename: "thumbnail_#{params[:shortcut_id]}.png", content_type: 'image/png')
    shortcut.assign_attributes(title: params[:shortcut_title])
    shortcut.save!
    current_user.update!(thumbnail_created_at: Time.current)
    render json: { image_url: url_for(shortcut.thumbnail) } # 生成した画像のURLを返す
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
    params.require(:shortcut).permit(:title, :status)
  end

  def shortcut_update_params
    params.require(:shortcut).permit(:title, :icon, :description, :download_url, :status, :instructions)
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
