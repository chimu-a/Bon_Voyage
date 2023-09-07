class PostItem < ApplicationRecord
  belongs_to :post
  has_many :comments, dependent: :destroy
end
