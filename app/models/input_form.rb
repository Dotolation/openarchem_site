class InputForm 
   include ActiveModel::Model
#  To do:
#  add new fields to form
#  restructure to use the form helpers?
#  pass form contents to this model
#  create methods in the other models to actually enter everything
#    new_oa_id
#    new_record

  def self.search_compounds(term)
    Compound.where('LOWER(formula) LIKE :term OR LOWER(name) LIKE :term', term: "%#{term.downcase}%")
  end

  def self.search_sites(term)
    Site.where('LOWER(name) LIKE :term', term: "%#{term.downcase}%")
  end

  def self.get_plants(oa_id)
    plant_list = Plant.get_plants_from_compound(oa_id)
  end

  def self.get_ingredients(oa_id)
    ingredient_list = Product.find_by_plant_id(oa_id)
  end

  def self.create_sample(params)
    #"user"=>"", "catalog_number"=>"", "current_location"=>"", "object_type"=>"", "site"=>"", 
    #"site_region"=>"", "ora_number"=>"", "sample_type"=>, "sample_quality"=>"", 
    #"sample_quality_notes"=>"", "commit"=>"Submit", "diagnostic_compound"=>"", "interpretation"=>"", 
    #"interpretation_certainty"=>"", "interpretation_notes"=>"", "object_condition"=>"", 
    #"relative_date"=>"", "absolute_date"=>"", "object_fabric"=>"", "excavation_team"=>"", 
    #"excavation_date"=>"", "excavation_notes"=>"", "context"=>"", "object_biblio"=>""
    #locus_name, locus_type, sample_date, sample_time, 
    #subsample_amount, gcms_analysis_date, stored_in_plastic, plastic_in_gcms, 
    #ided_substance, notes, site_id, source_id, equipment_id, 
    #extraction_id, chromatogram_id, vetted, 

    sample_fields
    equipment_fields["oa_id"] = Equipment.new_oa_id
    extraction_fields["oa_id"] = Extraction.new_oa_id
    object_fields["oa_id"] = Source.new_oa_id
    site_fields["oa_id"] = Site.new_oa_id
    image_fields["oa_id"] = Image.new_oa_id
    bibliography_fields["oa_id"] = Bibliography.new_oa_id

    params.each do |k, v|
      if k =~ /sample/
        k.gsub!(/sample_/, "")
        sample_fields[k] = v
      elsif k =~ /equipment/
        k.gsub!(/equipment_/, "")
        equipment_fields[k] = v
      elsif k =~ /extraction/
        k.gsub!(/extraction_/, "")
        extraction_fields[k] = v
      elsif k =~ /source/
        k.gsub!(/source_/, "")
        object_fields[k] = v
      elsif k =~ /site/
        k.gsub!(/site_/, "")
        site_fields[k] = v
      elsif k =~ /img/

        image_fields[k] = v
      
      end
           
    end

    @sample = Sample.new_sample(sample_fields)
    @extraction = Extraction.new_extraction(extraction_fields)
    @equipment = Equipment.new_equipment(equipment_fields)
    @source = Source.new_source(object_fields)
    @site = Site.new_site(site_fields)

  end

  def self.upload(uploaded_io, type)
    base = Rails.root.join('lib', 'assets', "images", "data")
    if type == "source"
      File.open(base.join('sources', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
        file.close
      end
    elsif type == "chrom"
      File.open(base.join('chromatograms', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
        file.close
      end
    elsif type == "petro"
      File.open(base.join('petrography', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
        file.close
      end
    end
        
  end


end