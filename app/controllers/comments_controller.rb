class CommentsController < ApplicationController
  def show
    @comment = Comment.find(params[:id])
  end
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post), notice: "Comment was successfully created." }
      end
    else
      redirect_to post_path(@post), status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
