class CreatePostItems < ActiveRecord::Migration[6.1]
  def change
    create_table :post_items do |t|
      t.integer :post_id, null: false
      t.string :place, null: false
      t.text :explanatory_text, null: false
      t.date :date, null: false
      t.time :time, null: false
      t.integer :moving_method
      t.integer :number_of_times
    end
  end
end
