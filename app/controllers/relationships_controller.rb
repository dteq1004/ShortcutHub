class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy ]

  def create
    user = User.find(params[:id])
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    redirect_to request.referer
  end

  def followings
    @user = User.find_by(uid: params[:uid])
    @users = @user.followings
    @shortcuts_count = @user.shortcuts.count
  end

  def followers
    @user = User.find_by(uid: params[:uid])
    @users = @user.followers
    @shortcuts_count = @user.shortcuts.count
  end
end
