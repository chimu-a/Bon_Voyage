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
    @post_item = comment.post_item
    comment.destroy
    # redirect_to request.referer
    if params[:key] == 'post_item'
      render :comment_destroy
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:customer_id, :post_item_id, :content)
  end
end
