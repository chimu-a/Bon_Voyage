class ApplicationController < ActionController::Base
  before_action :search

  def search
    @q = Post.ransack(params[:q])
    @post = @q.result(distinct: true)
    @results = params[:q]&.values&.reject(&:blank?)

    # @tag_search = Post.tagged_with(params[:search])
  end
end
