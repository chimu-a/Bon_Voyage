class PostItem < ApplicationRecord
  belongs_to :post
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :place, presence: true
  validates :explanatory_text, presence: true
  validates :date, presence: true
  validates :time, presence: true

  validate :date_within_post_period

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  private

  def date_within_post_period
    unless (post.start_date..post.end_date).cover?(date)
      errors.add(:date, ":投稿の旅行期間内に設定してください")
    end
  end
end
