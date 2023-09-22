class Admin::CommentsController < ApplicationController
  def index
    @posts = Post.page(params[:page]).per(2)
    @comments = Comment.all
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
    # if…で指定してあげることにより"destroy.js"を参照されるところを"comment_destroy.js"を参照に変更
    if params[:key] == 'post_item'
      render :comment_destroy
    end
    flash[:notice] = "コメントの削除に成功しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:customer_id, :post_item_id, :content)
  end
end
