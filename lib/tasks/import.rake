desc "Import Dukes"
  task :import_dukes => :environment do
    Compound.compounds_from_dukes
    Plant.import_dukes_plants
  end