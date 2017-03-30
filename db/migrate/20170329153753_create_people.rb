class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :oa_id, null: false
      t.string :last_name
      t.string :first_name
      t.string :affiliation
      t.timestamps
    end

    add_index :people, :oa_id, unique: true
  end
end
