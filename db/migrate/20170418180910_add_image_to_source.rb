class AddImageToSource < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :file_path, :string
    add_column :sources, :image_credit, :string
  end
end
