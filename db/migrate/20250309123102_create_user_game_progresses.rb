class CreateUserGameProgresses < ActiveRecord::Migration[7.2]
  def change
    create_table :user_game_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.text :answered_questions

      t.timestamps
    end
  end
end
