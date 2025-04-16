class UsersController < ApplicationController
  def show
    @user = User.find_by(uid: params[:uid])
    @shortcuts = @user.shortcuts.where(status: :published)
  end
end