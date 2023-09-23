class Public::HomesController < ApplicationController
  def top
    @post_count = Post.all
    @posts = Post.page(params[:page])
    @post = Post.new
    @post_items = @post.post_items.build
    @post_tags = @post.tags
  end

  def about
  end
end
