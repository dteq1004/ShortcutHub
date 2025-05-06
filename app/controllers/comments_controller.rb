class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @comment = Comment.includes(:user).find(params[:id])
    @shortcut = Shortcut.find(params[:shortcut_id])
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    redirect_to request.referer
  end

  def update
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id).merge(shortcut_id: params[:shortcut_id])
  end
end
