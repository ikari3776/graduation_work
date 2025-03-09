class CreateRateLimitInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :rate_limit_infos do |t|
      t.integer :limit
      t.integer :remaining

      t.timestamps
    end
  end
end
