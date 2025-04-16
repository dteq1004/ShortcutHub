class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find_by(uid: params[:uid])
    if @user === current_user
      @shortcuts = @user.shortcuts.all.order(created_at: :desc)
    else
      @shortcuts = @user.shortcuts.where(status: :published).order(created_at: :desc)
    end
  end

  def edit
  end

  def update
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
    redirect_to user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :uid)
  end

  def ensure_user
    @user = User.find_by(uid: params[:uid])
    if @user != current_user
      redirect_to user_path(@user)
    end
  end
end