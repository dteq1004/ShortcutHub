class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find_by(uid: params[:uid])
    unless @user != current_user
      redirect_to mypage_path
    end
  end

  def show_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @user = User.find_by(uid: params[:user_uid])
    @shortcuts = @user.shortcuts.where(status: :published).order(updated_at: :desc)
  end

  def edit
  end

  def update
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.update(user_params)
      redirect_to mypage_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path
  end

  def mypage
  end

  def mypage_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @shortcuts = current_user.shortcuts.all.order(updated_at: :desc)
  end

  def bookmarks
  end

  def bookmarks_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @bookmark_shortcuts = current_user.bookmark_shortcuts.includes(:user).order(updated_at: :desc)
  end

  def analytics
  end

  def analytics_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @shortcuts_view_count = current_user.shortcuts.where(status: :published).order(view_count: :desc).limit(5)
    @shortcuts_bookmark = Shortcut.where(status: :published).select('shortcuts.*, COUNT(bookmarks.id) AS bookmarks_count').left_joins(:bookmarks).where(user_id: current_user.id).group('shortcuts.id').order('bookmarks_count DESC').limit(5)
    @shortcuts_favorite = Shortcut.where(status: :published).select('shortcuts.*, COUNT(favorites.id) AS favorites_count').left_joins(:favorites).where(user_id: current_user.id).group('shortcuts.id').order('favorites_count DESC').limit(5)
  end

  private

  def user_params
    params.require(:user).permit(:name, :uid, :avatar)
  end

  def ensure_user
    @user = User.find_by(uid: params[:uid])
    if @user != current_user
      redirect_to user_path(@user)
    end
  end
end
