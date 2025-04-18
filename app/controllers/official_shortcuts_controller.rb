class OfficialShortcutsController < ApplicationController
  def index
    @shortcuts = OFFICIAL_SHORTCUTS
  end

  def show
    @shortcut = OFFICIAL_SHORTCUTS.find { |shortcut| shortcut["id"] == params[:id].to_i }
    if @shortcut.nil?
      redirect_to official_shortcuts_path
    end
  end
end
