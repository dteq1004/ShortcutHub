class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create destroy ]

  def create
    @user = User.find(params[:id])
    current_user.follow(@user)
    @user.create_notification_follow!(current_user)
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow(@user)
  end

  def followings
    @user = User.find_by(uid: params[:uid])
    @users = @user.followings
    if @user === current_user
      @shortcuts_count = @user.shortcuts.count
    else
      @shortcuts_count = @user.shortcuts.where(status: :published).count
    end
  end

  def followers
    @user = User.find_by(uid: params[:uid])
    @users = @user.followers
    if @user === current_user
      @shortcuts_count = @user.shortcuts.count
    else
      @shortcuts_count = @user.shortcuts.where(status: :published).count
    end
  end
end
