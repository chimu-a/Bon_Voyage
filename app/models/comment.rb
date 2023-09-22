class Comment < ApplicationRecord
   belongs_to :customer
   belongs_to :post_item

   validates :content, presence: true
end
