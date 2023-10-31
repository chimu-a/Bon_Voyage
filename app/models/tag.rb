class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  def self.search(search)
    if search != '#'
      tag = Tag.where(name: search)
      tag[0].cars
    else
      Post.all
    end
  end

  validates :name, presence:true, length:{maximum:50}
end