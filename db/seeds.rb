# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# admin = Admin.create!(email: "admin_@admin.com",
#                       password: "111111")
# Admin.create!(email: "admin@example.com",
# 　　　　　　　password: "password123")

Admin.create!(
  email: "admin@admin.com",
  password: "password123"
  )

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
tag_names = %w(一人旅
              日本
              絶景
              のんびり
              お酒
              グルメ
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
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/沖縄2.JPG"),
                                                  filename:"沖縄2.JPG"),
    post_items_attributes: [
      { place: "美ら海水族館",
        explanatory_text: "巨大水槽すごかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/美ら海水族館2.JPG"), filename:"美ら海水族館2.JPG"),
        date: date_times[0],
        time: date_times[0].to_time,
        moving_method: "車",
      },
      { place: "古宇利島",
        explanatory_text: "島までの橋からの景色綺麗でした！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/古宇利島2.JPG"), filename:"古宇利島2.JPG"),
        date: date_times[0],
        time: date_times[0].since(1.hours).to_time,
        moving_method: "車",
      }
    ]
  },
  # ここまでコピー
  { title: "東京旅行",
    start_date: date_times[1],
    end_date: date_times[1].since(2.days),
    prefecture_id: Prefecture.find_by(name: "東京都").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/東京タワー2.JPG"),
                                                  filename:"東京タワー2.JPG"),
    post_items_attributes: [
      { place: "スカイツリー",
        explanatory_text: "上からの眺め凄かったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/スカイツリー2.JPG"), filename:"スカイツリー2.JPG"),
        date: date_times[1],
        time: date_times[1].to_time,
        moving_method: "電車",
      },
      { place: "東京タワー",
        explanatory_text: "東京観光の定番ですね！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/東京タワー2.JPG"), filename:"東京タワー2.JPG"),
        date: date_times[1],
        time: date_times[1].since(1.hours).to_time,
        moving_method: "電車",
      },
      { place: "浅草寺",
        explanatory_text: "迫力ありました！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/浅草寺.JPG"), filename:"浅草寺.JPG"),
        date: date_times[1],
        time: date_times[1].since(2.hours).to_time,
        moving_method: "電車",
      },
      { place: "SHIBUYA SKY",
        explanatory_text: "混んでました！座る場所が沢山あり、長居してしまいました！",
        date: date_times[1],
        time: date_times[1].since(3.hours).to_time,
        moving_method: "電車",
      },
      { place: "YONA YONA BEER WORKS　新宿東口店",
        explanatory_text: "たくさん種類があってビール好きにはおすすめです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/よなよな.JPG"), filename:"よなよな.JPG"),
        date: date_times[1],
        time: date_times[1].since(4.hours).to_time,
        moving_method: "電車",
      },
      { place: "ドーミーインPREMIUM渋谷神宮前",
        explanatory_text: "サウナ最高でした！",
        date: date_times[1],
        time: date_times[1].since(5.hours).to_time,
        moving_method: "電車",
      }
    ]
  },
  { title: "大阪旅行",
    start_date: date_times[2],
    end_date: date_times[2].since(3.days),
    prefecture_id: Prefecture.find_by(name: "大阪府").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/大阪.JPG"),
                                                  filename:"大阪.JPG"),
    post_items_attributes: [
      { place: "ユニバーサルスタジオジャパン",
        explanatory_text: "1日楽しめました！マリオエリアの整理券取れず、残念でした、、",
        date: date_times[2],
        time: date_times[2].to_time,
        moving_method: "電車",
      },
      { place: "たこ昌　新大阪駅店",
        explanatory_text: "ふわとろで美味しかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/たこ昌.JPG"), filename:"たこ昌.JPG"),
        date: date_times[2],
        time: date_times[2].since(1.hours).to_time,
        moving_method: "電車",
      }
    ]
  },
  { title: "京都旅行",
    start_date: date_times[3],
    end_date: date_times[3].since(2.days),
    prefecture_id: Prefecture.find_by(name: "京都府").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/京都.JPG"),
                                                  filename:"京都.JPG"),
    post_items_attributes: [
      { place: "伏見稲荷大社",
        explanatory_text: "千本鳥居圧巻でした！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/伏見稲荷大社.JPG"), filename:"伏見稲荷大社.JPG"),
        date: date_times[3],
        time: date_times[3].to_time,
        moving_method: "自転車",
      },
      { place: "錦市場",
        explanatory_text: "お店が沢山！さくっと食べられる飲食店も多く、楽しかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/錦市場.JPG"), filename:"錦市場.JPG"),
        date: date_times[3],
        time: date_times[3].since(1.hours).to_time,
        moving_method: "自転車",
      }
    ]
  },
  { title: "函館旅行",
    start_date: date_times[4],
    end_date: date_times[4].since(2.days),
    prefecture_id: Prefecture.find_by(name: "北海道").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/五稜郭.JPG"),
                                                  filename:"五稜郭.JPG"),
    post_items_attributes: [
      { place: "きくよ食堂",
        explanatory_text: "海鮮丼美味しかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/きくよ食堂.JPG"), filename:"きくよ食堂.JPG"),
        date: date_times[4],
        time: date_times[4].to_time,
        moving_method: "バス",
      },
      { place: "五稜郭",
        explanatory_text: "雪景色も綺麗でしたが、桜の見頃にもう一度来てみたいです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/五稜郭.JPG"), filename:"五稜郭.JPG"),
        date: date_times[4],
        time: date_times[4].since(1.hours).to_time,
        moving_method: "バス",
      },
      { place: "金森赤レンガ倉庫",
        explanatory_text: "横浜と似てました！",
        date: date_times[4],
        time: date_times[4].since(2.hours).to_time,
        moving_method: "バス",
      },
      { place: "あじさい　函館駅店",
        explanatory_text: "あっさりしていて美味しかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/あしさい.JPG"), filename:"あしさい.JPG"),
        date: date_times[4],
        time: date_times[4].since(3.hours).to_time,
        moving_method: "バス",
      },
      { place: "函館山",
        explanatory_text: "天気が悪く登れず残念でした、、",
        date: date_times[4],
        time: date_times[4].since(4.hours).to_time,
        moving_method: "バス",
      },
      { place: "ラム",
        explanatory_text: "ジンギスカン美味しかったです！",
        date: date_times[4],
        time: date_times[4].since(5.hours).to_time,
        moving_method: "バス",
      }
    ]
  },
  { title: "岩手旅行",
    start_date: date_times[5],
    end_date: date_times[5].since(2.days),
    prefecture_id: Prefecture.find_by(name: "岩手県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/盛楼閣.JPG"),
                                                  filename:"盛楼閣.JPG"),
    post_items_attributes: [
      { place: "中尊寺",
        explanatory_text: "金色堂綺麗でした！",
        date: date_times[5],
        time: date_times[5].to_time,
        moving_method: "車",
      },
      { place: "盛楼閣",
        explanatory_text: "冷麺美味しかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/盛楼閣.JPG"), filename:"盛楼閣.JPG"),
        date: date_times[5],
        time: date_times[5].since(1.hours).to_time,
        moving_method: "車",
      }
    ]
  },
  { title: "宮城旅行",
    start_date: date_times[6],
    end_date: date_times[6].since(3.days),
    prefecture_id: Prefecture.find_by(name: "宮城県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/すし哲.JPG"),
                                                  filename:"すし哲.JPG"),
    post_items_attributes: [
      { place: "秋保大滝",
        explanatory_text: "迫力がありました！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/秋保大滝.JPG"), filename:"秋保大滝.JPG"),
        date: date_times[6],
        time: date_times[6].to_time,
        moving_method: "車",
      },
      { place: "ホテル　佐勘",
        explanatory_text: "老舗ホテルです！",
        date: date_times[6],
        time: date_times[6].since(1.hours).to_time,
        moving_method: "車",
      },
      { place: "仙台うみの杜水族館",
        explanatory_text: "ペンギンに癒されました！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/仙台うみの杜水族館.JPG"), filename:"仙台うみの杜水族館.JPG"),
        date: date_times[6],
        time: date_times[6].since(2.hours).to_time,
        moving_method: "車",
      },
      { place: "三井アウトレットパーク仙台港",
        explanatory_text: "水族館の近くです！観覧車がありました！",
        date: date_times[6],
        time: date_times[6].since(3.hours).to_time,
        moving_method: "車",
      },
      { place: "秋保大滝",
        explanatory_text: "迫力がありました！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/秋保大滝.JPG"), filename:"秋保大滝.JPG"),
        date: date_times[6],
        time: date_times[6].since(4.hours).to_time,
        moving_method: "車",
      },
      { place: "すし哲　仙台駅店",
        explanatory_text: "食べログの百名店に選出されている店です！大満足でした！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/すし哲.JPG"), filename:"すし哲.JPG"),
        date: date_times[6],
        time: date_times[6].since(5.hours).to_time,
        moving_method: "電車",
      }
    ]
  },
  { title: "高知旅行",
    start_date: date_times[7],
    end_date: date_times[7].since(2.days),
    prefecture_id: Prefecture.find_by(name: "高知県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/かつお.JPG"),
                                                  filename:"かつお.JPG"),
    post_items_attributes: [
      { place: "にこ淵",
        explanatory_text: "水が透き通っていて綺麗でした！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/にこ淵.JPG"), filename:"にこ淵.JPG"),
        date: date_times[7],
        time: date_times[7].to_time,
        moving_method: "車",
      },
      { place: "屋台安兵衛",
        explanatory_text: "高知も屋台が有名らしいです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/高知屋台.JPG"), filename:"高知屋台.JPG"),
        date: date_times[7],
        time: date_times[7].since(1.hours).to_time,
        moving_method: "車",
      }
    ]
  },
  { title: "島根旅行",
    start_date: date_times[7],
    end_date: date_times[7].since(2.days),
    prefecture_id: Prefecture.find_by(name: "島根県").id,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/出雲そは.JPG"),
                                                  filename:"出雲そは.JPG"),
    post_items_attributes: [
      { place: "出雲大社",
        explanatory_text: "縄大きかったです！",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/出雲大社.JPG"), filename:"出雲大社.JPG"),
        date: date_times[7],
        time: date_times[7].to_time,
        moving_method: "徒歩",
      },
      { place: "稲佐の浜",
        explanatory_text: "綺麗でした",
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/稲佐の浜JPG"), filename:"稲佐の浜.JPG"),
        date: date_times[7],
        time: date_times[7].since(1.hours).to_time,
        moving_method: "バス",
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