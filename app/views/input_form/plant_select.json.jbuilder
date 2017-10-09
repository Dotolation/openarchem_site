json.array!(@plants) do |plant|
  json.scientific_name    plant.scientific_name
  json.oa_id              plant.oa_id
end