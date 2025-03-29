require 'httparty'

class UnsplashService
  BASE_URL = 'https://api.unsplash.com/photos/random'
  PER_PAGE = 30

  def self.extract_photo_id(url)
    match = url.match(/photo-[^?]+/)
    match[0] if match
  end

  def self.fetch_and_save_images(total_images = 100)
    batches = (total_images / PER_PAGE.to_f).ceil

    existing_photo_ids = Image.pluck(:url).map { |u| extract_photo_id(u) }.compact.to_set

    batches.times do |i|
      url = "#{BASE_URL}?count=#{PER_PAGE}&content_filter=high&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}"
      response = HTTParty.get(url)

      if response.success?
        images = JSON.parse(response.body)

        images.each do |img|
          image_url = img['urls']['regular']
          photo_id = extract_photo_id(image_url)

          if existing_photo_ids.include?(photo_id)
            puts "スキップ（重複）: #{image_url}"
            next
          end

          Image.create!(url: image_url)
          existing_photo_ids.add(photo_id)
          puts "保存: #{image_url}"
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
