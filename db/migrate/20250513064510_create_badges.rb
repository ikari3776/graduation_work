class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.string :caption, null: false
      t.string :image, null: false
      t.datetime :achieved_at
    end
  end
end
