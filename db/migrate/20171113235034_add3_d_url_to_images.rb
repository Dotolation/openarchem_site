class Add3DUrlToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :sketchfab_url, :string
  end
end
