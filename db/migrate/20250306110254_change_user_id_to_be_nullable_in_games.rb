class ChangeUserIdToBeNullableInGames < ActiveRecord::Migration[7.2]
  def change
    change_column_null :games, :user_id, true
  end
end
