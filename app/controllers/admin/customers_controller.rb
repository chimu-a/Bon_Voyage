class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @customers = Customer.page(params[:page]).per(5)
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page]).per(3)
    @comments = @customer.comments
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    if @customer.save
      flash[:notice] = "会員情報を変更しました。"
      redirect_to admin_customer_path
    else
      render :edit
    end
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
    params.require(:customer).permit(:user_name, :last_name, :first_name, :last_name_kana, :first_name_kana, :email, :self_introduction, :is_deleted)
  end

  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
