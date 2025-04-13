class Image < ApplicationRecord
    scope :with_embeddings, -> { where.not(embedding: nil) }

    def self.rank_all_images(query_embedding)
      query_embedding = JSON.parse(query_embedding) if query_embedding.is_a?(String)
    
      Image
        .where.not(embedding_vector: nil)
        .order(Arel.sql("embedding_vector <-> '[#{query_embedding.join(',')}]'"))
        .map { |image| { image: image } }
    end
    
    def self.cosine_similarity(vec1, vec2)
      dot_product = vec1.zip(vec2).map { |a, b| a * b }.sum
      magnitude1 = Math.sqrt(vec1.map { |a| a**2 }.sum)
      magnitude2 = Math.sqrt(vec2.map { |a| a**2 }.sum)
      return 0 if magnitude1.zero? || magnitude2.zero?

      dot_product / (magnitude1 * magnitude2)
    end

    def embedding
      if attributes["embedding"].is_a?(String)
        attributes["embedding"].gsub(/[\[\]]/, "").split(",").map(&:to_f)
      else
        attributes["embedding"]
      end
    end
end
