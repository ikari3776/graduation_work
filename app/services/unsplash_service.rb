require 'net/http'
require 'json'

class UnsplashService
  BASE_URL = "https://api.unsplash.com/photos/random"
  ACCESS_KEY = ENV['UNSPLASH_ACCESS_KEY'] # `.env` から API キーを取得
  MAX_COUNT = 30 # 1回のリクエストで取得する最大枚数

  def self.fetch_random_images(total_images = 10000)
    urls = []
    (total_images / MAX_COUNT.to_f).ceil.times do |i|
      sleep 1 # API制限を考慮して1秒待機
      puts "Fetching batch #{i + 1}..."

      uri = URI("#{BASE_URL}?count=#{MAX_COUNT}&client_id=#{ACCESS_KEY}")
      response = Net::HTTP.get(uri)
      images = JSON.parse(response)

      images.each do |image|
        urls << image["urls"]["regular"] if image["urls"] && image["urls"]["regular"]
      end
    end
    urls
  end
end