class ChangeEmbeddingColumnTypeToJsonbInProductionOnly < ActiveRecord::Migration[7.2]
  def up
    return unless Rails.env.production?

    remove_column :images, :embedding
    add_column :images, :embedding, :jsonb
  end

  def down
    return unless Rails.env.production?

    remove_column :images, :embedding
    add_column :images, :embedding, :text
  end
end
