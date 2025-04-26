class SearchesController < ApplicationController
  before_action :set_q, only: [:index, :search]

  def index
    @shortcuts = if (tag_name = params[:tag_name])
      @q.result(distinct: true).includes(:user).joins(:tags).where(status: :published).where(tags: { name: tag_name }).order(created_at: :desc)
    else
      @q.result(distinct: true).includes(:user).joins(:tags).where(status: :published).order(created_at: :desc)
    end
  end

  def search
    @tags = Tag.where(id: Tagging.group(:tag_id).order("count_tag_id desc").limit(5).count(:tag_id).keys)
  end

  private

  def set_q
    @q = Shortcut.ransack(params[:q])
  end
end
