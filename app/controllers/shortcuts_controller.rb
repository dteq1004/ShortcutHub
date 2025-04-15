class ShortcutsController < ApplicationController
  before_action :hide_header, except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @shortcuts = Shortcut.includes(:user)
  end

  def show
    @shortcut = Shortcut.find(params[:id])
  end

  def new
    @shortcut = Shortcut.new
  end

  def create
    @shortcut = current_user.shortcuts.build(shortcut_new_params)
    if @shortcut.save
      redirect_to edit_shortcut_path(@shortcut)
    else
      flash.now[:alert] = "新規作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shortcut = current_user.shortcuts.find(params[:id])
  end

  def update
    @shortcut = current_user.shortcuts.find(params[:id])
    if @shortcut.update(shortcut_update_params)
      redirect_to shortcut_path(@shortcut)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def shortcut_new_params
    params.require(:shortcut).permit(:title)
  end

  def shortcut_update_params
    params.require(:shortcut).permit(:title, :description, :download_url)
  end

  def hide_header
    @show_header = false
  end
end
