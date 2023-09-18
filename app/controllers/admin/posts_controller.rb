class Admin::PostsController < ApplicationController
  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    @customer = @post.customer
    @post_tags = @post.tags
    # @comment = Comment.find(params[:id])
    @favorites = @post.favorites
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    4.times { @post.post_items.build }
  end

  def update
    post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if post.update(post_params)
      post.save_tags(tag_list)
      flash[:success] = "更新に成功しました"
      redirect_to post_path
    else
      render :edit
    end

  end

  def destroy
    post = Post.find(params[:id])
     @post.post_items.destroy_all
    post.destroy
      flash[:success] = "削除に成功しました"
      redirect_to '/posts'
  end

  private

  def post_params
    # Postitemモデルに渡す値をpost_items_attributesで設定
    params.require(:post).permit(:customer_id, :prefecture_id, :title, :start_date , :end_date, :image,
    post_items_attributes: [:id, :post_id, :place, :explanatory_text, :image, :date, :time, :moving_method, :number_of_times])
  end
end