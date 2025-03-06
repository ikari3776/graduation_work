class AddCategoryToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :category, :string
  end
end
