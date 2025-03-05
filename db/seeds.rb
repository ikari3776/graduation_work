require 'httparty'
require 'json'

API_KEY = ENV['PIXABAY_API_KEY']
QUERY = ["nature", "forest", "mountain", "beach", "river", "city", "sunset", "flowers"] # ここを好きなジャンルに変更
PER_PAGE = 200 # Pixabay は max 200 件まで取得可能
TOTAL_IMAGES = 200

def fetch_pixabay_images
  images = []

  while images.length < TOTAL_IMAGES
    query = QUERY.sample # ランダムなキーワードを選ぶ
    url = "https://pixabay.com/api/?key=#{API_KEY}&q=#{query}&image_type=photo&per_page=#{PER_PAGE}&page=1"
    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    if data["hits"].any?
      new_images = data["hits"].map { |hit| hit["webformatURL"] }
      images += new_images
      images.uniq! # 重複を防ぐ
    end
  end

  images.first(TOTAL_IMAGES) # 200 件に制限
end

# 画像 URL を取得して DB に保存
puts "画像を保存しています"
image_urls = fetch_pixabay_images

Image.insert_all(image_urls.map { |url| { url: url, created_at: Time.current, updated_at: Time.current } })

puts "#{image_urls.length}枚の画像がDBに保存されました"
