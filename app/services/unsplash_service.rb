require 'httparty'

class UnsplashService
  BASE_URL = 'https://api.unsplash.com/photos/random'
  PER_PAGE = 30
  MAX_IMAGES = 100

  def self.fetch_and_save_images(total_images = 100)
    batches = (total_images / PER_PAGE.to_f).ceil

    batches.times do |i|
      url = "#{BASE_URL}?count=#{PER_PAGE}&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}"
      response = HTTParty.get(url)

      if response.success?
        images = JSON.parse(response.body)
        existing_urls = Image.where(url: images.map { |img| img['urls']['regular'] }).pluck(:url).to_set
        images.each do |img|
          image_url = img['urls']['regular']
          unless existing_urls.include?(image_url)
            Image.create!(url: image_url)
            puts "保存: #{image_url}"
          else
            puts "スキップ（重複）: #{image_url}"
          end
        end
        puts "#{PER_PAGE} 枚保存完了！（#{(i + 1) * PER_PAGE}/#{total_images}）"
      else
        puts "エラー発生: #{response.body}"
      end

      sleep(1)
    end

    puts "合計 #{total_images} 枚の画像を保存しました！"
  end
end
