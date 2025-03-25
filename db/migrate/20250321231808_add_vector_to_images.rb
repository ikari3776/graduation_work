class AddVectorToImages < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'vector'

    execute <<-SQL
      ALTER TABLE images
      ADD COLUMN embedding vector(1536);
    SQL

    execute <<-SQL
      CREATE INDEX images_embedding_idx
      ON images
      USING ivfflat (embedding vector_l2_ops)
      WITH (lists = 100);
    SQL
  end
end
