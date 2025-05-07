class HomesController < ApplicationController
  def index
  end

  def index_lazy
    @latest_shortcuts = Shortcut.includes(:user).where(status: :published).order(created_at: :desc).limit(10)
    @popular_shortcuts = Shortcut
      .includes(:user)
      .where(status: :published)
      .select('shortcuts.*,
        COALESCE(view_count, 0) + COALESCE((SELECT COUNT(*) FROM bookmarks WHERE bookmarks.shortcut_id = shortcuts.id), 0) * 10 + COALESCE((SELECT COUNT(*) FROM favorites WHERE favorites.shortcut_id = shortcuts.id), 0) * 5 AS total_count')
      .order('total_count DESC')
      .limit(10)
    @official_shortcuts = OFFICIAL_SHORTCUTS
    @news = News.page(offset: 0, limit: 3)
    @users = User
      .select('users.*, COUNT(shortcuts.id) AS shortcut_count')
      .joins(:shortcuts)
      .where('shortcuts.created_at >= ?', 1.month.ago) # 過去1ヶ月の投稿に絞る
      .where(shortcuts: { status: :published })
      .group('users.id')
      .order('shortcut_count DESC')
      .limit(3)
  end
end
