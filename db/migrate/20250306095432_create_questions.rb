class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.references :game, foreign_key: true
      t.string :image_url
      t.string :search_word
      t.integer :rank
      t.integer :score

      t.timestamps
    end
  end
end
