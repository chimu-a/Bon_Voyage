class Admin::CommentsController < ApplicationController
  def index
    @posts = Post.page(params[:page]).per(10)
    @comments = Comment.page(params[:page]).per(10)
    # @customer = @posts.customer
  end

  def show
  end

  def destroy
    comment = Comment.find(params[:id])
    @post = comment.post_item.post
    comment.destroy
    # redirect_to request.referer
  end

  private

  def comment_params
    params.require(:comment).permit(:customer_id, :post_item_id, :content)
  end
end
