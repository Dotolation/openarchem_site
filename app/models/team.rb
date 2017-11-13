class Team < ActiveRecord::Base
  has_many :people, foreign_key: :oa_id
  has_many :samples, foreign_key: :oa_id

  def self.new_oa_id
    oa_id = Team.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

  def self.new_member(vals_hash)
    @team = Team.create(vals_hash)
  end
end