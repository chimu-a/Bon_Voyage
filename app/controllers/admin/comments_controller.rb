class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @posts = Post.all
    @posts = Post.includes(post_items: :comments).where.not(comments: { id: nil } ).page(params[:page]).per(2)
    @comments = Comment.all
  end

  def show
  end

  def destroy
    comment = Comment.find(params[:id])
    @post = comment.post_item.post
    @post_item = comment.post_item
    comment.destroy
    # redirect_to request.referer
    # if…で指定→参照先が"destroy.js"から"comment_destroy.js"に変更
    if params[:key] == "post_item"
      render :comment_destroy
    end
    flash[:notice] = "コメントの削除に成功しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:customer_id, :post_item_id, :content)
  end
end
