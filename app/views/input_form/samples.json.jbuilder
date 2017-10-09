json.array!(@compounds) do |compound|
  json.formula    compound.formula
  json.name       compound.name
  json.oa_id      compound.oa_id
end