class AddStatusToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :status, :integer
  end
end
