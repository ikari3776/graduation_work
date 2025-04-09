require 'open-uri'
require 'fileutils'
require 'base64'
require 'net/http'
require 'json'

API_KEY = ENV['OPENAI_API_KEY']
MAX_IMAGES = 1000
TEMP_DIR = "tmp/images"

FileUtils.mkdir_p(TEMP_DIR)

def download_image(image_url, file_path)
  URI.open(image_url) do |image|
    File.open(file_path, "wb") do |file|
      file.write(image.read)
    end
  end
  puts "画像ダウンロード完了: #{file_path}"
end

def encode_image_to_base64(file_path)
  Base64.strict_encode64(File.read(file_path))
end

def generate_caption(file_path)
  image_data = encode_image_to_base64(file_path)

  uri = URI('https://api.openai.com/v1/chat/completions')
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request['Authorization'] = "Bearer #{API_KEY}"

  request.body = {
    model: 'gpt-4o',
    messages: [
      { role: 'system', content: 'あなたは画像の内容を日本語で簡潔に説明するAIです。100トークン以内で、重要な情報のみを要約してください。' },
      {
        role: 'user',
        content: [
          "この画像の内容を100トークン以内で簡潔に説明してください。",
          {
            type: 'image_url',
            image_url: {
              url: "data:image/jpeg;base64,#{image_data}"
            }
          }
        ]
      }
    ],
    max_tokens: 100,
    temperature: 0.3
  }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  if response.code == '200'
    result = JSON.parse(response.body)
    caption = result['choices'][0]['message']['content']
    return caption.strip
  else
    puts "キャプション生成エラー: #{response.body}"
    return nil
  end
end

def process_images
  images = Image.where(caption: nil).limit(MAX_IMAGES)

  images.each_with_index do |image, index|
    file_path = "#{TEMP_DIR}/image_#{index + 1}.jpg"

    download_image(image.url, file_path)

    caption = generate_caption(file_path)

    if caption
      image.update(caption: caption)
      puts "キャプション生成完了: #{image.url} → #{caption}"
    else
      puts "キャプション生成失敗: #{image.url}"
    end

    File.delete(file_path) if File.exist?(file_path)
    puts "画像削除完了: #{file_path}"
  end

  puts "1000枚分のキャプション生成 & 画像削除完了！"
end

process_images

