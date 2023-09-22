class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.page(params[:page]).per(2)
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
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

  private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :self_introduction, :is_deleted)
  end
end
