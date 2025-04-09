require 'httparty'

class UnsplashService
  BASE_URL = 'https://api.unsplash.com/search/photos'
  PER_PAGE = 30
  QUERIES = ['sports']


  def self.extract_photo_id(url)
    match = url.match(/photo-[^?]+/)
    match[0] if match
  end

  def self.fetch_and_save_images
    existing_photo_ids = Image.pluck(:url).map { |u| extract_photo_id(u) }.compact.to_set

    QUERIES.each do |query|
      total_saved = 0

      (31..32).each do |page|
        break if total_saved >= 30

        url = "#{BASE_URL}?query=#{query}&per_page=#{PER_PAGE}&page=#{page}&content_filter=high&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}"
        response = HTTParty.get(url)

        if response.success?
          images = JSON.parse(response.body)['results']

          images.each do |img|
            image_url = img['urls']['regular']
            photo_id = extract_photo_id(image_url)

            next if existing_photo_ids.include?(photo_id)

            Image.create!(url: image_url)
            existing_photo_ids.add(photo_id)
            total_saved += 1

            puts "保存: #{image_url} (#{query}の合計: #{total_saved}/30)"
            break if total_saved >= 30
          end
        else
          puts "エラー発生（#{query} - ページ #{page}）: #{response.body}"
        end

        sleep(1)
      end

      puts "#{query} の画像取得完了（合計: #{total_saved}/30）"
    end
  end
end
