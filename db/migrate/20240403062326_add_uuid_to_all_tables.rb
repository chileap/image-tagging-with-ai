class AddUuidToAllTables < ActiveRecord::Migration[7.1]
  TABLES = [:users, :images]

  def up
    TABLES.each do |table|
      add_column table, :uuid, :uuid, default: "gen_random_uuid()", null: false
      add_index table, :uuid, unique: true
    end
  end

  def down
    TABLES.each do |table|
      remove_column table, :uuid
    end
  end
end
