class Public::PostsController < ApplicationController
  before_action :authenticate_customer!, except: [:top]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  def index
    # タグ名押すと絞り込んで表示される
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.page(params[:page]).per(8)
      @post_count = @tag.posts.all
    else
      @posts = Post.page(params[:page]).per(8)
      @post_count = Post.all
    end
    @post = Post.new
    @post_items = @post.post_items.build
    @post_tags = @post.tags
    @prefectures = Prefecture.all
  end

  def new
    @post = Post.new
    10.times { @post.post_items.build }
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にして配列に格納して tag_list という変数に代入
    tag_list = params[:post][:name].split(',')
    @post.post_items.each do |post_item|
      unless (@post.start_date..@post.end_date).cover?(post_item.date)
        @post.errors.add(:日時, ":投稿の旅行期間内に設定してください")
        10.times { @post.post_items.build }
        render :new
        return
      end
    end
    if @post.save
      @post.save_tags(tag_list)
      flash[:notice] = "投稿に成功しました"
      redirect_to post_path(@post.id)
    else
      10.times { @post.post_items.build }
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    @customer = @post.customer
    @post_tags = @post.tags
    @comment = Comment.new
    @post_items = PostItem.where(post_id: @post.id).order_by_date_time.page(params[:page]).per(5)
    @prefectures = Prefecture.all
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    10.times { @post.post_items.build }
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')

    if @post.update(post_params)
      @post.save_tags(tag_list)
      flash[:notice] = "投稿の更新に成功しました"
      redirect_to post_path
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
      redirect_to '/posts'
  end

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = Tag.all
    　#検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
    　#検索されたタグに紐づく投稿を表示
    @posts = @tag.posts
  end

  private

  def post_params
    # Postitemモデルに渡す値をpost_items_attributesで設定
    params.require(:post).permit(:customer_id, :prefecture_id, :title, :start_date , :end_date, :image, :privacy,
    post_items_attributes: [:id, :post_id, :place, :explanatory_text, :image, :date, :time, :moving_method, :number_of_times])
  end

  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.customer.id == current_customer.id
      redirect_to posts_path
    end
  end
end