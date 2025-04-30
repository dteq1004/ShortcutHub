class FollowsController < ApplicationController
  before_action :authenticate_user!, only: [ :index, :index_lazy ]

  def index
    @shortcuts = Shortcut.includes(:user).where(user_id: current_user.followings).where(status: :published).order(created_at: :desc)
  end

  def index_lazy
    @shortcuts = Shortcut.includes(:user).where(user_id: current_user.followings).where(status: :published).order(created_at: :desc)
  end
end
