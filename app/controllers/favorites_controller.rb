class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @shortcut = Shortcut.find(params[:shortcut_id])
    current_user.favorite(@shortcut)
    @shortcut.create_notification_favorite!(current_user)
  end

  def destroy
    @shortcut = current_user.favorites.find(params[:id]).shortcut
    current_user.unfavorite(@shortcut)
  end
end
