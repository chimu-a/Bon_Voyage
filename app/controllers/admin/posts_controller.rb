class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
     if params[:tag_id].present?
        @tag = Tag.find(params[:tag_id])
        @posts = @tag.posts.page(params[:page]).per(8)
        @post_count = @tag.posts.all
     else
        @posts = Post.page(params[:page]).per(8)
        @post_count = Post.all
     end
  end

  def show
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    @customer = @post.customer
    @post_tags = @post.tags
    @favorites = @post.favorites
    @post_items = PostItem.where(post_id: @post.id).page(params[:page]).per(5)
   @prefectures = Prefecture.all
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    10.times { @post.post_items.build }
  end

  def update
    post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if post.update(post_params)
      post.save_tags(tag_list)
      flash[:notice] = "投稿の更新に成功しました"
      redirect_to admin_post_path
    else
      10.times { @post.post_items.build }
      render :edit
    end

  end

  def destroy
    post = Post.find(params[:id])
    post.post_items.destroy_all
    post.destroy
      flash[:notice] = "投稿の削除に成功しました"
      redirect_to admin_posts_path
  end

  private

  def post_params
    # Postitemモデルに渡す値をpost_items_attributesで設定
    params.require(:post).permit(:customer_id, :prefecture_id, :title, :start_date , :end_date, :image,
    post_items_attributes: [:id, :post_id, :place, :explanatory_text, :image, :date, :time, :moving_method, :number_of_times])
  end
end