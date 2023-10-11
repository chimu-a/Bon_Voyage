class Post < ApplicationRecord
  # 下記記載でモジュールを取り込んでいる
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

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
  accepts_nested_attributes_for :post_items, allow_destroy: true, reject_if: :all_blank, limit: 20

  validates_associated :post_items

  validates :prefecture_id, numericality: { other_than: 1, message: "を入力してください" }
  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :post_items, presence: true
  # validates :privacy, presence: true

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

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = Tag.all
    　#検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
    　#検索されたタグに紐づく投稿を表示
    @posts = @tag.posts
  end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    # ["created_at", "customer_id", "end_date", "id", "prefecture_id", "start_date", "title", "updated_at"]
    %w(title prefecture_id)
  end

  def self.ransackable_associations(auth_object = nil)
    # ["customer", "favorites", "image_attachment", "image_blob", "post_items", "post_tags", "prefecture", "tags"]
    %w(prefecture)
  end

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def get_mini_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize: '350x350', gravity: :center, crop: "250x250+0+0")
  end

  # 曖昧検索
  def self.search(keyword, prefs)
    # joinsで各テーブルを結合して1つのテーブルとみなす
    # LIKEであいまい検索(%は何が入ってもOK)
    # INで配列を検索(SQLでのwhereInのこと)
    # joinsで繋いだ先を検索する場合は、テーブル名とカラム名を「.」で連結させる
    joins(:tags, :post_items)
          .where('title LIKE ? OR tags.name LIKE ? OR post_items.place LIKE ? OR post_items.explanatory_text LIKE ? OR post_items.moving_method LIKE ? OR prefecture_id IN (?)',
                  "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", prefs)
  end
end
