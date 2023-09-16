class PostItem < ApplicationRecord
  belongs_to :post
  has_many :comments, dependent: :destroy
  has_one_attached :image

  # def self.search(search)
  #   if search != nil
  #     PostItem.where('place LIKE(?)' ,'explanatory_text LIKE(?)' , "%#{search}%", "%#{search}%")
  #   else
  #     Post.all
  #   end
  # end
end
