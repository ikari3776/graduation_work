class AddImageIdToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :image_id, :integer
  end
end
