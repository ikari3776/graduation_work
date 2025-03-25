class ChangeEmbeddingColumnTypeToJsonb < ActiveRecord::Migration[7.2]
  def change
    change_column :images, :embedding, :jsonb, using: 'embedding::jsonb'
  end
end
