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


  def self.get_plants(oa_id)
    plant_list = Plant.get_plants_from_compound(oa_id)
  end


end