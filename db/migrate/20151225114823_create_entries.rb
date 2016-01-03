class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.string :title
      t.integer :num

      t.timestamps null: false
    end
  end
end
