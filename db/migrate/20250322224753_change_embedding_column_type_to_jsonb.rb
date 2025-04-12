class ChangeEmbeddingColumnTypeToJsonb < ActiveRecord::Migration[7.2]
  def change
    unless Rails.env.production?
      change_column :images, :embedding, :jsonb, using: 'embedding::jsonb'
    end
  end
end
