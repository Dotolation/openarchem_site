class AddFkColumns < ActiveRecord::Migration
  def change

  	add_column :samples, :site_id, :string
  	add_column :samples, :source_id, :string
  	add_column :samples, :equipment_id, :string
  	add_column :samples, :chromatogram_id, :string
  	add_column :sites, :director_id, :string
  	add_column :chromatograms, :sample_id, :string
  	add_column :chromatograms, :compound_id, :string
  	add_column :peaks, :chromatogram_id, :string
  	add_column :collectors, :sample_id, :string
		add_column :collectors, :person_id, :string
		add_column :major_compounds, :sample_id, :string
		add_column :major_compounds, :compound_id, :string
		add_column :identifications, :sample_id, :string
		add_column :identifications, :plant_id, :string
		add_column :identifications, :animal_id, :string
		add_column :plant_compounds, :compound_id, :string
		add_column :plant_compounds, :plant_id, :string
		add_column :animal_compounds, :compound_id, :string
		add_column :animal_compounds, :animal_id, :string

  end
end
