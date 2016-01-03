class AddDateTimeToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entry_date, :date
    add_column :entries, :entry_time, :integer
  end
end
