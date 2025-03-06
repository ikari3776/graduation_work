require 'httparty'
require 'json'

API_KEY = ENV['PIXABAY_API_KEY']
QUERIES = ["food", "animal", "sports", "people", "hobby", "vehicles", "clothing", "emotions", "objects", "landmarks"]
PER_PAGE = 200 # Pixabay の max は 200 件
TOTAL_IMAGES_PER_CATEGORY = 600 # 目標は 10000 枚
SLEEP_TIME = 0.5

def fetch_pixabay_images(query)
  images = []
  page = 1

  while images.length < TOTAL_IMAGES_PER_CATEGORY
    url = "https://pixabay.com/api/?key=#{API_KEY}&q=#{query}&image_type=photo&per_page=#{PER_PAGE}&page=#{page}"

    response = HTTParty.get(url)
    
    if response.code != 200
      puts "APIエラー: #{response.code} (#{query})"
      sleep(5) # エラー時は5秒待ってリトライ
      next
    end

    data = JSON.parse(response.body)

    if data["hits"].any?
      new_images = data["hits"].map { |hit| hit["webformatURL"] }
      images += new_images
      images = images.uniq # 重複削除
    end

    page += 1
    break if data["hits"].empty? || images.length >= TOTAL_IMAGES_PER_CATEGORY

    sleep(SLEEP_TIME) # API 制限回避
  end

  images.first(TOTAL_IMAGES_PER_CATEGORY) # 1000 件に制限
end


# 各カテゴリごとに取得 & 保存
QUERIES.each do |query|
  puts "カテゴリ '#{query}' の画像を取得中..."
  image_urls = fetch_pixabay_images(query)

  if image_urls.any?
    Image.insert_all(image_urls.map { |url| { url: url, category: query, created_at: Time.current, updated_at: Time.current } })
    puts "#{image_urls.length} 枚の画像が '#{query}' カテゴリとして DB に保存されました"
  else
    puts "カテゴリ '#{query}' の画像が取得できませんでした"
  end

  sleep(2) # 各カテゴリごとに少し待機（API 制限対策）
end

puts "✅ すべての画像の取得が完了しました！"
