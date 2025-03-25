class Image < ApplicationRecord
    scope :with_embeddings, -> { where.not(embedding: nil) }
  
    # 余計な serialize を削除！（embedding は JSON 型なので不要）
    # serialize :embedding, JSON  ← これを削除！
  
    def self.find_similar_images(query_embedding, limit: 10)
      # query_embedding が String なら変換（DB のデータは JSON 型なので、基本 Array のはず）
      query_embedding = JSON.parse(query_embedding) if query_embedding.is_a?(String)
  
      images = Image.with_embeddings.limit(100) # 100件の画像を対象
      scores = images.map do |image|
        embedding = image.embedding # ここで JSON をパースしない！（すでに Array のはず）
        similarity = cosine_similarity(query_embedding, embedding)
        { image: image, similarity: similarity }
      end
  
      scores.sort_by { |h| -h[:similarity] }.first(limit) # 類似度が高い順にソートし、制限を適用
    end
  
    def self.cosine_similarity(vec1, vec2)
      dot_product = vec1.zip(vec2).map { |a, b| a * b }.sum
      magnitude1 = Math.sqrt(vec1.map { |a| a**2 }.sum)
      magnitude2 = Math.sqrt(vec2.map { |a| a**2 }.sum)
      return 0 if magnitude1.zero? || magnitude2.zero?
  
      dot_product / (magnitude1 * magnitude2)
    end
end  
