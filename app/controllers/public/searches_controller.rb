class Public::SearchesController < ApplicationController
  def search
  if (params[:keyword])[0] == '#'
    @posts = Tag.search(params[:keyword]).order('created_at DESC')
  else
    @posts = Post.search(params[:keyword]).order('created_at DESC')
  end
end
end
