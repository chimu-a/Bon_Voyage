class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  # "through: :post_tags"は2つのモデル間の関連が"post_tagsモデル"を通して行われることを示す
  has_many :posts, through: :post_tags

  def self.search(search)
    if search != '#'
      tag = Tag.where(name: search)
      tag[0].cars
    else
      Post.all
    end
  end
end
