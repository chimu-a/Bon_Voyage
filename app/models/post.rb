class Post < ApplicationRecord
  # 下記記載でモジュールを取り込んでいる
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  has_many :post_tags, dependent: :destroy
  # "through: :post_tags"は2つのモデル間の関連が"post_tagsモデル"を通して行われることを示す
  has_many :tags, through: :post_tags
  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :post_items, dependent: :destroy
  has_one_attached :image
end
