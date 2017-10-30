json.array!(@ingredients) do |ingredient|
  json.name    ingredient.name
  json.oa_id   ingredient.oa_id
end