class Public::CommentsController < ApplicationController
  def index
  end

  def create
    @post_item = PostItem.find(params[:post_item_id])
    comment = current_customer.comments.new(comment_params)
    comment.post_item_id = @post_item.id
    comment.save
    @post = @post_item.post
    # redirect_to post_path(post)
  end

  def destroy
    @post_item = PostItem.find(params[:post_item_id])
    Comment.find(params[:id]).destroy
    # redirect_to post_path(params[:post_item_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
