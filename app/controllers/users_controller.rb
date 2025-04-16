class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]

  def show
    @user = User.find_by(uid: params[:uid])
    if @user === current_user
      @shortcuts = @user.shortcuts.all.order(created_at: :desc)
    else
      @shortcuts = @user.shortcuts.where(status: :published).order(created_at: :desc)
    end
  end

  def mypage
    redirect_to user_path(current_user)
  end
end