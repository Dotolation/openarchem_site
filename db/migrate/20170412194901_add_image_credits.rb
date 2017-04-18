class AddImageCredits < ActiveRecord::Migration[5.0]
  def change

  	add_column :plants, :image_credit, :string
  	add_column :animals, :image_credit, :string
  	add_column :compounds, :image_credit, :string

  end
end
