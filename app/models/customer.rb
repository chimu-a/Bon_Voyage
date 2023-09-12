class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.user_name = "ゲストユーザー"
      customer.last_name = "ゲスト"
      customer.first_name = "ユーザー"
      customer.last_name_kana = "ゲスト"
      customer.first_name_kana = "ユーザー"
      customer.self_introduction = "ゲストユーザーです。"
    end
  end

  def active_for_authentication?
    super && (self.is_deleted == false)
  end

end
