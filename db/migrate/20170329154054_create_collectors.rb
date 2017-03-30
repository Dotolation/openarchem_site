class CreateCollectors < ActiveRecord::Migration
  def change
    create_table :collectors do |t|

      t.timestamps
    end
  end
end
