class Public::PostsController < ApplicationController
  def index
    # タグ名押すと絞り込んで表示される
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.page(params[:page])
    else
      @posts = Post.page(params[:page])
    end
    # @posts = Post.all
    # 追記
    @post = Post.new
    @post_items = @post.post_items.build
    # @tag_list = Tag.all
    @post_tags = @post.tags
    @prefectures = ['北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県','滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県']
    # @search = Post.ransack(params[:q])
    # @results = @search.result
    # if params[:new_post]
    #   @posts = Post.new_post
    # elsif params[:old_post]
    #   @posts = Post.old_post
    # else
    #   @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all
    # end
    # if params[:keyword]
    #   @posts = @posts.search(params[:keyword]).page(params[:page])
    # else
    #   @posts = @posts.page(params[:page])
    # end
    # @keyword = params[:keyword]
  end

  def new
    @post = Post.new
    4.times { @post.post_items.build }
    # @post_items = @post.post_items.build
    # 4.times { @post_items }
    # @form = Form::PostItemCollection.new
  end

  def create
    # @form = Form::PostItemCollection.new(post_item_collection_params)
    post = Post.new(post_params)
    post.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にして配列に格納して tag_list という変数に代入
    tag_list = params[:post][:name].split(',')
    if post.save
      post.save_tags(tag_list)
      flash[:notice] = "投稿に成功しました"
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    @customer = @post.customer
    @post_tags = @post.tags
    @comment = Comment.new
    @prefectures = ['北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県','滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県']
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
      flash[:notice] = "投稿の更新に成功しました"
      redirect_to post_path
    else
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



  # def search
  #   # キーワード検索
  #   @search = Post.ransack(params[:q])
  #   @results = @search.result.order("created_at DESC").page(params[:page]).per(10)

  #   # タグ検索
  #   @tag_search = Post.tagged_with(params[:search])
  # end

  private

  def post_params
    # Postitemモデルに渡す値をpost_items_attributesで設定
    params.require(:post).permit(:customer_id, :prefecture_id, :title, :start_date , :end_date, :image,
    post_items_attributes: [:id, :post_id, :place, :explanatory_text, :image, :date, :time, :moving_method, :number_of_times])
  end


  # def post_item_collection_params
  #       params.require(:form_post_item_collection)
  #       .permit(post_items_attributes: Form::PostItem::REGISTRABLE_ATTRIBUTES)
  # end
end