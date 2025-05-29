class SearchesController < ApplicationController
  before_action :set_q, only: %i[ index search ]

  def index
    @shortcuts = if (tag_name = params[:tag_name])
      @q.result(distinct: true).includes(:user).joins(:tags).where(status: :published).where(tags: { name: tag_name }).order(created_at: :desc)
    else
      @q.result(distinct: true).includes(:user).where(status: :published).order(created_at: :desc)
    end
  end

  def search
    @tags = Tag.where(id: Tagging.group(:tag_id).order("count_tag_id desc").limit(10).count(:tag_id).keys)
  end

  def autocomplete
    unless request.format.json?
      redirect_to root_path and return
    end
    q = Shortcut.ransack(title_or_description_cont: params[:q])
    shortcuts = q.result(distinct: true).where(status: :published).limit(5).pluck(:title).uniq
    render json: shortcuts
  end

  private

  def set_q
    @q = Shortcut.ransack(params[:q])
  end
end
