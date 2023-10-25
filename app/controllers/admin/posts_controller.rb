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
    @prefectures = ['北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県','滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県']
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
      redirect_to '/admin/posts'
  end

  private

  def post_params
    # Postitemモデルに渡す値をpost_items_attributesで設定
    params.require(:post).permit(:customer_id, :prefecture_id, :title, :start_date , :end_date, :image,
    post_items_attributes: [:id, :post_id, :place, :explanatory_text, :image, :date, :time, :moving_method, :number_of_times])
  end
end