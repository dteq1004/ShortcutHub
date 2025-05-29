class HomesController < ApplicationController
  def index
    @official_shortcuts = OFFICIAL_SHORTCUTS
  end

  def latest_shortcuts
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @latest_shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc).limit(10)
  end

  def popular_shortcuts
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @popular_shortcuts = Shortcut.includes(:user).where(status: :published).select("shortcuts.*,
    COALESCE(view_count, 0) + COALESCE((SELECT COUNT(*) FROM bookmarks WHERE bookmarks.shortcut_id = shortcuts.id), 0) * 10 + COALESCE((SELECT COUNT(*) FROM favorites WHERE favorites.shortcut_id = shortcuts.id), 0) * 5 AS total_count").order("total_count DESC").limit(10)
  end

  def user_ranking
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @users = User.select("users.*, COUNT(shortcuts.id) AS shortcut_count").joins(:shortcuts).where("shortcuts.created_at >= ?", 1.month.ago).where(shortcuts: { status: :published }).group("users.id").order("shortcut_count DESC").limit(3)
  end

  def news
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @news = News.page(offset: 0, limit: 3)
  end
end
