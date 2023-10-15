class ApplicationController < ActionController::Base
  # before_action :search

  def search
  end

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = Tag.all
      #検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
      #検索されたタグに紐づく投稿を表示
    @posts = @tag.posts
  end
  end