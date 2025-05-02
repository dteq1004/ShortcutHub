class FollowsController < ApplicationController
  before_action :authenticate_user!, only: [ :index, :index_lazy ]

  def index
  end

  def index_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @shortcuts = Shortcut.includes(:user).where(user_id: current_user.followings).where(status: :published).order(created_at: :desc)
  end
end
