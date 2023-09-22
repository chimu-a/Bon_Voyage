class PostItem < ApplicationRecord
  belongs_to :post
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :place, presence: true
  validates :explanatory_text, presence: true
  validates :date, presence: true
  validates :time, presence: true

 def get_image
    if image.attached?
      image
    else
      'noimage.jpg'
    end
  end

  # def self.search(search)
  #   if search != nil
  #     PostItem.where('place LIKE(?)' ,'explanatory_text LIKE(?)' , "%#{search}%", "%#{search}%")
  #   else
  #     Post.all
  #   end
  # end
end
