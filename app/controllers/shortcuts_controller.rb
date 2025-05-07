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
    @latest_shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc)
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
      redirect_to edit_shortcut_path(@shortcut)
    else
      flash.now[:alert] = "新規作成に失敗しました"
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
      redirect_to user_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shortcut = current_user.shortcuts.find(params[:id])
    @shortcut.destroy!
  end

  def archived
    shortcut = current_user.shortcuts.find(params[:id])
    shortcut.status = "archived"
    if shortcut.save
      redirect_to mypage_path, notice: "非公開にしました！"
    else
      redirect_to mypage_path, alert: "エラーが発生しました"
    end
  end

  def search
    @tags = Tag.where("name LIKE ?", "%#{params[:query]}").order(created_at: :desc).pluck(:name)
    render json: @tags
  end

  private

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
