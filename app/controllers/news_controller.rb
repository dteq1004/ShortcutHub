class NewsController < ApplicationController
  def index
    @news = News.page
  end

  def show
    @news = News.find(params[:id])
  end
end
