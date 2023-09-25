class PostItem < ApplicationRecord
  belongs_to :post
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :place, presence: true
  validates :explanatory_text, presence: true
  validates :date, presence: true
  validates :time, presence: true

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

end
