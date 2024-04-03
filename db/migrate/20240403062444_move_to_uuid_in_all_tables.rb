class MoveToUuidInAllTables < ActiveRecord::Migration[7.1]
  TABLES = [:users, :images]

  def up
    TABLES.each do |table|
      # migrate to UUID PKs
      rename_column table, :id, :numeric_id
      rename_column table, :uuid, :id
      change_pk(table)
      remove_index table, :id if index_exists?(table, :id)
      remove_index table, :numeric_id if index_exists?(table, :numeric_id)
    end
  end

  def down
    TABLES.each do |table|
      # rollback to numeric PKs
      rename_column table, :id, :uuid
      rename_column table, :numeric_id, :id
      change_pk(table)
      add_index table, :uuid, unique: true
    end
  end

  def change_pk(table)
    execute "ALTER TABLE #{table} DROP CONSTRAINT #{table}_pkey;"
    execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
  end
end
