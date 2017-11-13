class Publication < ActiveRecord::Base
  
  def self.new_oa_id
    oa_id = Publication.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

  def self.new_publication(vals_hash)
    @publication = Publication.create(vals_hash)
  end

  def self.find_publication(id)
    unless id.empty?
      pub = Publication.where("oa_id = ?", id)
    else
      return nil
    end
    return pub
  end

end