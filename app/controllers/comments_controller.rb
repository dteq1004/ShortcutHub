class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @comment = Comment.includes(:user).find(params[:id])
    @shortcut = Shortcut.find(params[:shortcut_id])
  end

  def create
    if params[:comment][:parent_id].present?
      @parent_comment_id = params[:comment][:parent_id]
    end
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def edit
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @comment = current_user.comments.find(params[:id])
    if @comment.parent_id.present?
      @parent_comment_id = @comment.parent_id
    end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_params.except(:shortcut_id))
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
