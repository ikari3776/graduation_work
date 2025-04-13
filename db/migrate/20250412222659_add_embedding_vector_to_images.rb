class AddEmbeddingVectorToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :embedding_vector, :vector, limit: 1536
  end
end
