# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170329184843) do

  create_table "animal_compounds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "compound_id"
    t.string   "animal_id"
  end

  add_index "animal_compounds", ["animal_id"], name: "anc_ani_idx", using: :btree
  add_index "animal_compounds", ["compound_id"], name: "anc_com_idx", using: :btree

  create_table "animals", force: true do |t|
    t.string   "oa_id",           null: false
    t.string   "scientific_name"
    t.string   "common_name"
    t.text     "description"
    t.string   "image_file_path"
    t.string   "reference_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animals", ["oa_id"], name: "index_animals_on_oa_id", unique: true, using: :btree

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "user_type"
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "document_type"
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "chromatograms", force: true do |t|
    t.string   "oa_id",       null: false
    t.string   "file_path"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "compound_id"
  end

  add_index "chromatograms", ["compound_id"], name: "chr_com_idx", using: :btree
  add_index "chromatograms", ["oa_id"], name: "index_chromatograms_on_oa_id", unique: true, using: :btree
  add_index "chromatograms", ["sample_id"], name: "chr_sam_idx", using: :btree

  create_table "collectors", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "person_id"
  end

  add_index "collectors", ["person_id"], name: "col_pea_idx", using: :btree
  add_index "collectors", ["sample_id"], name: "col_sam_idx", using: :btree

  create_table "compounds", force: true do |t|
    t.string   "oa_id",            null: false
    t.string   "formula"
    t.float    "molecular_weight"
    t.string   "name"
    t.string   "image_file_path"
    t.boolean  "ancient"
    t.string   "outside_db_url"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compounds", ["oa_id"], name: "index_compounds_on_oa_id", unique: true, using: :btree

  create_table "equipment", force: true do |t|
    t.string   "oa_id",               null: false
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "year"
    t.string   "column_manufacturer"
    t.string   "column_model"
    t.text     "settings"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "equipment", ["oa_id"], name: "index_equipment_on_oa_id", unique: true, using: :btree

  create_table "extractions", force: true do |t|
    t.string   "oa_id",           null: false
    t.string   "solvent"
    t.boolean  "buchi"
    t.boolean  "swished"
    t.boolean  "boiled_manually"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extractions", ["oa_id"], name: "index_extractions_on_oa_id", unique: true, using: :btree

  create_table "identifications", force: true do |t|
    t.string   "oa_id",      null: false
    t.string   "certainty"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "plant_id"
    t.string   "animal_id"
  end

  add_index "identifications", ["animal_id"], name: "ide_ani_idx", using: :btree
  add_index "identifications", ["oa_id"], name: "index_identifications_on_oa_id", unique: true, using: :btree
  add_index "identifications", ["plant_id"], name: "ide_pla_idx", using: :btree
  add_index "identifications", ["sample_id"], name: "ide_sam_idx", using: :btree

  create_table "major_compounds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "compound_id"
  end

  add_index "major_compounds", ["compound_id"], name: "maj_com_idx", using: :btree
  add_index "major_compounds", ["sample_id"], name: "maj_sam_idx", using: :btree

  create_table "peaks", force: true do |t|
    t.string   "oa_id",                null: false
    t.integer  "peak_number"
    t.float    "retention_time"
    t.integer  "peak_height"
    t.integer  "peak_area"
    t.float    "peak_area_div_height"
    t.float    "relative_abundance"
    t.float    "absolute_abundance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "chromatogram_id"
  end

  add_index "peaks", ["chromatogram_id"], name: "pea_chr_idx", using: :btree
  add_index "peaks", ["oa_id"], name: "index_peaks_on_oa_id", unique: true, using: :btree

  create_table "people", force: true do |t|
    t.string   "oa_id",       null: false
    t.string   "last_name"
    t.string   "first_name"
    t.string   "affiliation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["oa_id"], name: "index_people_on_oa_id", unique: true, using: :btree

  create_table "plant_compounds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "compound_id"
    t.string   "plant_id"
  end

  add_index "plant_compounds", ["compound_id"], name: "plc_com_idx", using: :btree
  add_index "plant_compounds", ["plant_id"], name: "plc_pla_idx", using: :btree

  create_table "plants", force: true do |t|
    t.string   "oa_id",           null: false
    t.string   "scientific_name"
    t.string   "common_name"
    t.text     "description"
    t.string   "image_file_path"
    t.string   "dukes_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plants", ["oa_id"], name: "index_plants_on_oa_id", unique: true, using: :btree

  create_table "samples", force: true do |t|
    t.string   "oa_id",              null: false
    t.string   "archem_id"
    t.string   "site_orig_id"
    t.string   "locus_name"
    t.string   "locus_type"
    t.date     "sample_date"
    t.time     "sample_time"
    t.string   "subsample_amount"
    t.date     "gcms_analysis_date"
    t.boolean  "stored_in_plastic"
    t.boolean  "plastic_in_gcms"
    t.boolean  "ided_substance"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site_id"
    t.string   "source_id"
    t.string   "equipment_id"
    t.string   "chromatogram_id"
  end

  add_index "samples", ["chromatogram_id"], name: "sam_chr_idx", using: :btree
  add_index "samples", ["equipment_id"], name: "sam_equ_idx", using: :btree
  add_index "samples", ["oa_id"], name: "index_samples_on_oa_id", unique: true, using: :btree
  add_index "samples", ["source_id"], name: "sam_sou_idx", using: :btree

  create_table "searches", force: true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "sites", force: true do |t|
    t.string   "oa_id",       null: false
    t.string   "geo_coords"
    t.string   "name"
    t.string   "project_url"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "director_id"
  end

  add_index "sites", ["director_id"], name: "sit_per_idx", using: :btree
  add_index "sites", ["oa_id"], name: "index_sites_on_oa_id", unique: true, using: :btree

  create_table "sources", force: true do |t|
    t.string   "oa_id",            null: false
    t.string   "coords"
    t.boolean  "soil_sample"
    t.text     "notes"
    t.string   "object_condition"
    t.string   "object_type"
    t.string   "petrography"
    t.string   "object_treatment"
    t.boolean  "published"
    t.string   "object_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["oa_id"], name: "index_sources_on_oa_id", unique: true, using: :btree

end
