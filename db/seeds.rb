require 'httparty'
require 'json'

API_KEY = ENV['PIXABAY_API_KEY']
QUERY = "animal"
PER_PAGE = 200 # Pixabay の max は 200 件
TOTAL_IMAGES = 1000 # 目標は 1000 枚

def fetch_pixabay_images
  images = []
  page = 1

  while images.length < TOTAL_IMAGES
    url = "https://pixabay.com/api/?key=#{API_KEY}&q=#{QUERY}&image_type=photo&per_page=#{PER_PAGE}&page=#{page}"

    response = HTTParty.get(url)
    
    if response.code != 200
      puts "APIエラー: #{response.code}"
      break
    end

    data = JSON.parse(response.body)

    if data["hits"].any?
      new_images = data["hits"].map { |hit| hit["webformatURL"] }
      images += new_images
      images = images.uniq # 重複削除
    end

    page += 1
    break if data["hits"].empty? || images.length >= TOTAL_IMAGES
  end

  images.first(TOTAL_IMAGES) # 1000 件に制限
end

# 画像 URL を取得して DB に保存
puts "画像を保存しています"
image_urls = fetch_pixabay_images

if image_urls.any?
  Image.insert_all(image_urls.map { |url| { url: url, created_at: Time.current, updated_at: Time.current } })
  puts "#{image_urls.length}枚の画像がDBに保存されました"
else
  puts "画像が取得できませんでした"
end
