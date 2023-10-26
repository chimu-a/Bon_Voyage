class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, except: [:top]
  before_action :is_matching_login_user, only: [:edit, :update, :unsubscribe, :withdraw, :favorites, :comments]
  before_action :set_customer, only: [:favorites]

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page]).per(2)
    @comment_posts = @customer.posts.includes(post_items: :comments).where.not(comments: { id: nil } ).page(params[:page]).per(2)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    if @customer.save
      flash[:notice] = "会員情報を変更しました。"
      redirect_to customer_path
    else
      render :edit
    end
  end

  def unsubscribe
    @customer = Customer.find(params[:id])
  end

  def withdraw
    customer = Customer.find(params[:id])
    customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理が完了しました。"
    redirect_to root_path
  end

  def favorites
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
  end

  def comments
    @customer = Customer.find(params[:id])
    # Comment モデルに関連付けられた PostItem の外部キーである post_item_id を使用
    comments = Comment.where(customer_id: @customer.id).pluck(:post_item_id)
     # 取得した post_item_id を使用して、関連する投稿（Post）の ID を取得
    post_ids = PostItem.where(id: comments).pluck(:post_id)
     # 関連する投稿（Post）を取得
    @comment_posts = Post.where(id: post_ids)
  end

private

  def customer_params
    params.require(:customer).permit(:user_name, :last_name, :first_name, :last_name_kana, :first_name_kana, :email, :self_introduction)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def is_matching_login_user
    customer = Customer.find(params[:id])
    if !customer_signed_in? || (customer.id != current_customer.id) || (current_customer.email == 'guest@example.com')
      redirect_to customer_path(current_customer.id)
    end
  end
end