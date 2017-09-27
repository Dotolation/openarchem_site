class AncientRef < ActiveRecord::Base

  def self.find_by_prod_id(id)
    unless id.empty?
      ref = AncientRef.where("product_id = ?", id)
    else
      return nil
    end
    return ref
  end
end