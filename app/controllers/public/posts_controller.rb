class Public::PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    @post_items = @post.post_items.build
    2.times { @post.post_items.build }
    @form = Form::PostItemCollection.new
  end

  def create
    @form = Form::PostItemCollection.new(post_item_collection_params)
    post = Post.new(post_params)
    # 受け取った値を,で区切って配列にして配列に格納して tag_list という変数に代入
    tag_list = params[:post][:name].split(',')
    if @form.save
      @form.save_tags(tag_list)
      flash[:success] = "投稿に成功しました"
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      flash[:success] = "更新に成功しました"
      redirect_to post_path(@post)
    else
      render :edit
    end

  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
      flash[:success] = "削除に成功しました"
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
    params.require(:post).permit(:customer_id, :prefecture_id, :title, :date ,:image, :post_items_attributes [:id, :place, :explanatory_text])
  end


  def post_item_collection_params
        params.require(:form_post_item_collection)
        .permit(post_items_attributes: Form::PostItem::REGISTRABLE_ATTRIBUTES)
  end
end