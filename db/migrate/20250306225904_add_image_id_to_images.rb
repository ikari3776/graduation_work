class AddImageIdToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :image_id, :integer
  end
end
