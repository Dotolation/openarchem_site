class AddAllForeignKeys < ActiveRecord::Migration
  def change
  	
#maybe one day we'll be able to upgrade to Rails 5... But for now, ugly sql statements it is...
=begin
  	add_foreign_key :samples, :sites, column: :site_id, primary_key: "oa_id"
  	add_foreign_key :samples, :sources, column: :source_id, primary_key: "oa_id"
  	add_foreign_key :samples, :extractions, column: :extract_process_id, primary_key: "oa_id"
  	add_foreign_key :samples, :equipment, column: :equipment_id, primary_key: "oa_id"
  	add_foreign_key :samples, :chromatograms, column: :chromatogram_id, primary_key: "oa_id"
  	add_foreign_key :sites, :people, column: :director_id, primary_key: "oa_id"
  	add_foreign_key :chromatograms, :samples, column: :sample_id, primary_key: "oa_id"
  	add_foreign_key :chromatograms, :compounds, column: :compound_id, primary_key: "oa_id"
  	add_foreign_key :peaks, :chromatograms, column: :chromatogram_id, primary_key: "oa_id"
  	add_foreign_key :collectors, :people, column: :person_id, primary_key: "oa_id"
  	add_foreign_key :collectors, :samples, column: :sample_id, primary_key: "oa_id"
  	add_foreign_key :sample_compounds, :samples, column: :sample_id, primary_key: "oa_id"
  	add_foreign_key :sample_compounds, :compounds, column: :compound_id, primary_key: "oa_id"
  	add_foreign_key :identifications, :samples, column: :sample_id, primary_key: "oa_id"
  	add_foreign_key :identifications, :products, column: :product_id, primary_key: "oa_id"
  	add_foreign_key :plant_compounds, :compounds, column: :plant_id, primary_key: "oa_id"
  	add_foreign_key :plant_compounds, :plants, column: :plant_id, primary_key: "oa_id"
  	add_foreign_key :animal_compounds, :compounds, column: :compound_id, primary_key: "oa_id"
  	add_foreign_key :animal_compounds, :animals, column: :animal_id, primary_key: "oa_id"
=end

#samples table

		execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_sit_id`
      FOREIGN KEY (`site_id` )
      REFERENCES `openarchem`.`sites` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_sit_idx` (`site_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_sou_id`
      FOREIGN KEY (`source_id` )
      REFERENCES `openarchem`.`sources` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_sou_idx` (`source_id` ASC) ;
    SQL

  
    execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_equ_id`
      FOREIGN KEY (`equipment_id` )
      REFERENCES `openarchem`.`equipment` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_equ_idx` (`equipment_id` ASC) ;
    SQL


    execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_ext_id`
      FOREIGN KEY (`extraction_id` )
      REFERENCES `openarchem`.`extractions` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_ext_idx` (`extraction_id` ASC) ;
    SQL

	
    execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_chr_id`
      FOREIGN KEY (`chromatogram_id` )
      REFERENCES `openarchem`.`chromatograms` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_chr_idx` (`chromatogram_id` ASC) ;
    SQL

#sites table

	
  	execute <<-SQL
      ALTER TABLE `openarchem`.`sites` 
      ADD CONSTRAINT `sit_per_id`
      FOREIGN KEY (`director_id` )
      REFERENCES `openarchem`.`people` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sit_per_idx` (`director_id` ASC) ;
   	SQL
      
#chromatograms table

	
		execute <<-SQL
      ALTER TABLE `openarchem`.`chromatograms` 
      ADD CONSTRAINT `chr_sam_id`
      FOREIGN KEY (`sample_id` )
      REFERENCES `openarchem`.`samples` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `chr_sam_idx` (`sample_id` ASC) ;
    SQL

  
    execute <<-SQL
      ALTER TABLE `openarchem`.`chromatograms` 
      ADD CONSTRAINT `chr_com_id`
      FOREIGN KEY (`compound_id` )
      REFERENCES `openarchem`.`compounds` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `chr_com_idx` (`compound_id` ASC) ;
    SQL

#peaks table

	
    execute <<-SQL
      ALTER TABLE `openarchem`.`peaks` 
      ADD CONSTRAINT `pea_chr_id`
      FOREIGN KEY (`chromatogram_id` )
      REFERENCES `openarchem`.`chromatograms` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `pea_chr_idx` (`chromatogram_id` ASC) ;
    SQL

#collectors table

	
		execute <<-SQL
      ALTER TABLE `openarchem`.`collectors` 
      ADD CONSTRAINT `col_sam_id`
      FOREIGN KEY (`sample_id` )
      REFERENCES `openarchem`.`samples` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `col_sam_idx` (`sample_id` ASC) ;
    SQL

 
    execute <<-SQL
      ALTER TABLE `openarchem`.`collectors` 
      ADD CONSTRAINT `col_pea_id`
      FOREIGN KEY (`person_id` )
      REFERENCES `openarchem`.`people` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `col_pea_idx` (`person_id` ASC) ;
    SQL

#major compounds table

	
		execute <<-SQL
      ALTER TABLE `openarchem`.`sample_compounds` 
      ADD CONSTRAINT `sac_sam_id`
      FOREIGN KEY (`sample_id` )
      REFERENCES `openarchem`.`samples` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sac_sam_idx` (`sample_id` ASC) ;
    SQL

  
    execute <<-SQL
      ALTER TABLE `openarchem`.`sample_compounds` 
      ADD CONSTRAINT `sac_com_id`
      FOREIGN KEY (`compound_id` )
      REFERENCES `openarchem`.`compounds` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sac_com_idx` (`compound_id` ASC) ;
    SQL

#identifications table

	
    execute <<-SQL
      ALTER TABLE `openarchem`.`identifications` 
      ADD CONSTRAINT `ide_sam_id`
      FOREIGN KEY (`sample_id` )
      REFERENCES `openarchem`.`samples` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `ide_sam_idx` (`sample_id` ASC) ;
    SQL

  
    execute <<-SQL
      ALTER TABLE `openarchem`.`identifications` 
      ADD CONSTRAINT `ide_pro_id`
      FOREIGN KEY (`product_id` )
      REFERENCES `openarchem`.`products` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `ide_pro_idx` (`product_id` ASC) ;
    SQL

#plant compounds table

	
		execute <<-SQL
      ALTER TABLE `openarchem`.`plant_compounds` 
      ADD CONSTRAINT `plc_com_id`
      FOREIGN KEY (`compound_id` )
      REFERENCES `openarchem`.`compounds` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `plc_com_idx` (`compound_id` ASC) ;
    SQL

  
    execute <<-SQL
      ALTER TABLE `openarchem`.`plant_compounds` 
      ADD CONSTRAINT `plc_pla_id`
      FOREIGN KEY (`plant_id` )
      REFERENCES `openarchem`.`plants` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `plc_pla_idx` (`plant_id` ASC) ;
    SQL

#animal compounds table    

	
		execute <<-SQL
      ALTER TABLE `openarchem`.`animal_compounds` 
      ADD CONSTRAINT `anc_com_id`
      FOREIGN KEY (`compound_id` )
      REFERENCES `openarchem`.`compounds` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `anc_com_idx` (`compound_id` ASC) ;
    SQL

  
    execute <<-SQL
      ALTER TABLE `openarchem`.`animal_compounds` 
      ADD CONSTRAINT `anc_ani_id`
      FOREIGN KEY (`animal_id` )
      REFERENCES `openarchem`.`animals` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `anc_ani_idx` (`animal_id` ASC) ;
    SQL

#products table

    execute <<-SQL
      ALTER TABLE `openarchem`.`products` 
      ADD CONSTRAINT `pro_ani_id`
      FOREIGN KEY (`animal_id` )
      REFERENCES `openarchem`.`animals` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `pro_ani_idx` (`animal_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`products` 
      ADD CONSTRAINT `pro_pla_id`
      FOREIGN KEY (`plant_id` )
      REFERENCES `openarchem`.`plants` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `pro_pla_idx` (`plant_id` ASC) ;
    SQL

#product_compounds

    execute <<-SQL
      ALTER TABLE `openarchem`.`product_compounds` 
      ADD CONSTRAINT `prc_pro_id`
      FOREIGN KEY (`product_id` )
      REFERENCES `openarchem`.`products` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `prc_pro_idx` (`product_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`product_compounds` 
      ADD CONSTRAINT `prc_com_id`
      FOREIGN KEY (`compound_id` )
      REFERENCES `openarchem`.`compounds` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `prc_com_idx` (`compound_id` ASC) ;
    SQL

  end
end
