class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.references :user, foreign_key: true
      t.integer :total_score
      t.datetime :finished_at

      t.timestamps
    end
  end
end
