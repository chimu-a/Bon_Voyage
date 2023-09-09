class Form::PostItemCollection < Form::Base
  # FORM_COUNT = 10 #ここで、作成したい登録フォームの数を指定
  attr_accessor :post_items

  def initialize(attributes = {})
    # super attributes
    # self.post_items = FORM_COUNT.times.map { PostItem.new() } unless self.post_items.present?
  end

  def post_items_attributes=(attributes)
    self.post_items = attributes.map { |_, v| PostItem.new(v) }
  end

  def save
    Post.transaction do
      self.post_items.map(&:save!)
        end
      return true
    rescue => e
      return false
  end
end
