json.array!(@sites) do |site|
  json.name       site.name
  json.region     site.region
end