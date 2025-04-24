class HomesController < ApplicationController
  def index
    @shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc).limit(10)
    @official_shortcuts = OFFICIAL_SHORTCUTS
    @news = News.page(offset: 0, limit: 3)
  end
end
