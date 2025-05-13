class RemoveCaptionFromBadge < ActiveRecord::Migration[7.2]
  def change
    remove_column :badges, :caption, :string
  end
end
