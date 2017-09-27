class SampleCompound < ActiveRecord::Base

  def self.find_by_sample_id(oa_id)
    unless oa_id.empty?
      #may have several return rows, so give back the group of activerecords
      s_comp = SampleCompound.where("sample_id = ?", oa_id)
    else
      return nil
    end
  end

  def self.find_by_compound_id(oa_id)
    unless oa_id.empty?
      #may have several return rows, so give back the group of activerecords
      s_comp = SampleCompound.where("compound_id = ?", oa_id)
    else 
      return nil
    end
  end

  def self.get_plants_for_sample(sample_id)

    sc_list = SampleCompound.find_by_sample_id(sample_id)

    comp_and_plant_hash = Hash.new

    sc_list.each do |rec|
      plant_recs = PlantCompound.find_by_compound_id(rec["compound_id"])
      
      #THIS WILL NEED TO BE CHANGED
      #at the moment we only have one to one correlations from compounds to plants, eventually one compound
      #will probably map to several plants, probable plant source will need to be determined by statistics or
      #by explicit identification
      plant_recs.each do |p_rec|
        comp = Compound.find_compound(p_rec["compound_id"])
        plant = Plant.find_plant(p_rec["plant_id"])
        prod = Product.find_by_plant_id(p_rec["plant_id"]).first
        a_ref = AncientRef.find_by_prod_id(prod["oa_id"])
        comp_and_plant_hash[comp["name"]] = [comp["oa_id"], comp["dukes_url"], comp["nist_url"], plant["scientific_name"], plant["oa_id"], plant["dukes_url"], plant["flora_url"], prod["name"], a_ref]
      end
    end
    return comp_and_plant_hash
  end

end
