class ChangeEmbeddingColumnTypeInImages < ActiveRecord::Migration[7.2]
  def up
    unless Rails.env.production?
      change_column :images, :embedding, :text
      change_column :images, :embedding, :json, using: 'embedding::json'
    end
  end

  def down
    unless Rails.env.production?
      change_column :images, :embedding, :text
      change_column :images, :embedding, :vector
    end
  end
end
