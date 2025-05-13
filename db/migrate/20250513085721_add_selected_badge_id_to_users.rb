class AddSelectedBadgeIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :selected_badge_id, :integer
  end
end
