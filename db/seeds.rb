# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = Admin.create!(email: "admin_@admin.com",
                      password: '111111')
# ここから下を繰り返す
# ランダムなデータ
# 1https://magazine.techacademy.jp/magazine/37864
# 2gem faker
# 1..10のところ変える
customers = (1..10).map do |i|
  user_name = Faker::Japanese::Name.name
  last_name = Faker::Japanese::Name.last_name
  last_name_kana = last_name.yomi
  first_name = Faker::Japanese::Name.first_name
  first_name_kana = first_name.yomi
  Customer.create!(email: "user_#{i}@example.com",
                              user_name: user_name,
                              last_name: last_name,
                              first_name: first_name,
                              last_name_kana: last_name_kana,
                              first_name_kana: first_name_kana,
                              self_introduction: ["旅行大好きです！", "よろしくお願いします"].sample,
                              password: "password")
end

# タグ追記
tag_names = %w(1泊2日
              沖縄
              旅行)
              
tag_names.each do |name|
  Tag.create!(name: name)
end

date_times = customers.size.times.map{ Faker::Time.between(from: Time.zone.now.ago(30.days), to: Time.zone.now.ago(10.days)).in_time_zone }

# 新たに作る時はここから
customers_attributes = [
  { title: "沖縄旅行",
    start_date: date_times[0],
    end_date: date_times[0].since(3.days),
    prefecture_id: Prefecture.find_by(name: "沖縄県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/沖縄.jpg"),
                                                  filename:"沖縄.jpg"),
    post_items_attributes: [
      { place: "美ら海水族館",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館.jpg"), filename:"美ら海水族館.jpg"),
        date: date_times[0],
        time: date_times[0].to_time,
        moving_method: "車",
      },
      { place: "美ら海水族館2",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館.jpg"), filename:"美ら海水族館.jpg"),
        date: date_times[0],
        time: date_times[0].since(1.hours).to_time,
        moving_method: "車",
      }
    ]
  },
  # ここまでコピー
  { title: "沖縄旅行B",
    start_date: date_times[1],
    end_date: date_times[1].since(3.days),
    prefecture_id: Prefecture.find_by(name: "沖縄県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/沖縄.jpg"),
                                                  filename:"沖縄.jpg"),
    post_items_attributes: [
      { place: "美ら海水族館3",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館.jpg"), filename:"美ら海水族館.jpg"),
        date: date_times[1],
        time: date_times[1].to_time,
        moving_method: "車",
      },
      { place: "美ら海水族館4",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館.jpg"), filename:"美ら海水族館.jpg"),
        date: date_times[1],
        time: date_times[1].since(1.hours).to_time,
        moving_method: "車",
      },
      { place: "美ら海水族館5",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館.jpg"), filename:"美ら海水族館.jpg"),
        date: date_times[1],
        time: date_times[1].since(2.hours).to_time,
        moving_method: "車",
      }
    ]
  },
  { title: "沖縄旅行c",
    start_date: date_times[2],
    end_date: date_times[2].since(3.days),
    prefecture_id: Prefecture.find_by(name: "沖縄県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/沖縄.jpg"),
                                                  filename:"沖縄.jpg"),
    post_items_attributes: [
      { place: "美ら海水族館3",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館.jpg"), filename:"美ら海水族館.jpg"),
        date: date_times[2],
        time: date_times[2].to_time,
        moving_method: "車",
      }
    ]
  },
  {},
  {},
  {},
  {},
  {},
  {},
  {}
]



customers.each.with_index(0) do |customer, i|
  puts "----->　index[#{i}]Start"
  post = customer.posts.create(customers_attributes[i])
  if post.persisted?
    puts "#-----> post Created"
    Tag.ids.sample(rand(1..tag_names.size)).each do |tag_id|
      post.post_tags.create!(tag_id: tag_id)
    end
    puts "##-----> post.tags Created"
  end
  puts nil
end
# ここまで