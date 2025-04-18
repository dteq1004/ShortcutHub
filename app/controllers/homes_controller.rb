class HomesController < ApplicationController
  def index
    @shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc)
    @official_shortcuts = OFFICIAL_SHORTCUTS
  end
end
