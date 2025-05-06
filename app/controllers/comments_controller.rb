class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @comment = Comment.includes(:user).find(params[:id])
    @shortcut = Shortcut.find(params[:shortcut_id])
  end

  def create
    if params[:comment][:parent_id].present?
      @parent_comment = Comment.find(params[:comment][:parent_id])
    end
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def update
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id).merge(shortcut_id: params[:shortcut_id])
  end
end
