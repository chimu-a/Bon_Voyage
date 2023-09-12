class Public::CustomersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :unsubscribe, :withdraw]
  before_action :set_customer, only: [:favorites]

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    customer.update(customer_params)
    if @customer.save
      redirect_to customer_path
    else
      render :edit
    end
  end

  def unsubscribe
    @customer = Customer.find(params[:id])
  end

  def withdraw
    @customer = Customer.find(params[:id])
    customer.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  def favorites
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
  end

private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :self_introduction)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def is_matching_login_user
    customer = Customer.find(params[:id])
    unless customer.id == current_customer.id
      redirect_to customer_path(current_customer.id)
    end
  end

end
