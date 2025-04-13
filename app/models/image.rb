class Image < ApplicationRecord
  def self.rank_all_images(query_embedding)
    query_embedding = JSON.parse(query_embedding) if query_embedding.is_a?(String)
    query_vector = query_embedding.join(",")

    subquery = Image
      .select("id, url, embedding_vector <-> '[#{query_vector}]' AS distance")
      .where.not(embedding_vector: nil)
      .to_sql

    from("(#{subquery}) AS images_with_distance")
      .select("*")
      .order("distance")
      .limit(100)
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
