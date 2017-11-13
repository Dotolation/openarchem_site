class SampleCompound < ActiveRecord::Base

  def self.new_sample_compound(vals_hash)
    @sample_compound = SampleCompound.create(vals_hash)
  end
  
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
        comp = Compound.find_compound(rec["compound_id"])
        plant = Plant.find_plant(rec["plant_id"])
        prod = Product.find_product(rec["product_id"])
        if prod
          a_ref = AncientRef.find_by_prod_id(prod["oa_id"])
          p_name = prod["name"]
        else 
          a_ref = []
          p_name = nil
        end

        comp_and_plant_hash[comp["name"]] = [comp["oa_id"], comp["dukes_url"], comp["nist_url"], plant["scientific_name"], plant["oa_id"], plant["dukes_url"], plant["flora_url"], p_name, a_ref]
      
    end
    return comp_and_plant_hash
  end

end
