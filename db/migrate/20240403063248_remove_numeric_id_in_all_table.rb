class RemoveNumericIdInAllTable < ActiveRecord::Migration[7.1]
  # we did this migration because we don't have data in the database yet. If we already have data and it is important to keep the data, we should not do this migration.

  TABLES = [:users, :images]

  def up
    TABLES.each do |table|
      remove_column table, :numeric_id
    end
  end

  def down
    TABLES.each do |table|
      execute "CREATE SEQUENCE IF NOT EXISTS #{table}_id_seq"
      add_column table, :numeric_id, :bigint, null: false, default: -> { "nextval('#{table}_id_seq'::regclass)" }
    end
  end
end
