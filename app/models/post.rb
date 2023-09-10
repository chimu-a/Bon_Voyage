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

  # accepts_nested_attributes_for:controllerにてpost_itemsが使えるようにする
  # allow_destroy: true:親モデルのフォームで子モデルの削除を許可
  # reject_if: :all_blank:空の子モデルは作成されない
  accepts_nested_attributes_for :post_items, allow_destroy: true, reject_if: :all_blank, limit: 8

  validates :prefecture_id, numericality: { other_than: 1}

  def save_tags(tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = tags - current_tags

    # 古いタグを消す
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    # 新しいタグを保存
    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name:new_name)
      self.tags << tag
    end
  end
end
