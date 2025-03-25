class ChangeEmbeddingColumnTypeInImages < ActiveRecord::Migration[7.2]
  def up
    change_column :images, :embedding, :text
    change_column :images, :embedding, :json, using: 'embedding::json'
  end

  def down
    change_column :images, :embedding, :text
    change_column :images, :embedding, :vector
  end
end
