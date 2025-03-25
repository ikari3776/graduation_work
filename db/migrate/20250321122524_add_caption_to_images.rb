class AddCaptionToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :caption, :text
  end
end
