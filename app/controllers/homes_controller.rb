class HomesController < ApplicationController
  def index
    @shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc)
  end
end
