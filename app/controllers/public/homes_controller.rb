class Public::HomesController < ApplicationController
  def top
    @posts = Post.all
    @post = Post.new
    @post_items = @post.post_items.build
    @post_tags = @post.tags
  end

  def about
  end
end
