class ChangeEmbeddingToVector < ActiveRecord::Migration[7.2]
  def change
    change_column :images, :embedding, :vector, limit: 1536
  end
end
