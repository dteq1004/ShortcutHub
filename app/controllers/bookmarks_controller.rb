class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @shortcut = Shortcut.find(params[:shortcut_id])
    current_user.bookmark(@shortcut)
    @shortcut.create_notification_bookmark!(current_user)
  end

  def destroy
    @shortcut = current_user.bookmarks.find(params[:id]).shortcut
    current_user.unbookmark(@shortcut)
  end
end
