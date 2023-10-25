class Public::CommentsController < ApplicationController
  before_action :authenticate_customer!, except: [:top]
  before_action :is_matching_login_user, only: [:destroy]
  def index
  end

  def create
    @post_item = PostItem.find(params[:post_item_id])
    comment = current_customer.comments.new(comment_params)
    comment.post_item_id = @post_item.id
    comment.save
    @post = @post_item.post
  end

  def destroy
    @post_item = PostItem.find(params[:post_item_id])
    Comment.find(params[:id]).destroy
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  private

  def is_matching_login_user
    customer = Customer.find(params[:id])
    unless customer.id == current_customer.id
      redirect_to posts_path
    end
  end
end