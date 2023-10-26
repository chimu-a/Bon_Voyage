class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :email, uniqueness: true
  validates :encrypted_password, presence: true
  validates :user_name, presence: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true

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

  def guest?
    email == 'guest@example.com'
  end

end
