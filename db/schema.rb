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

ActiveRecord::Schema.define(version: 20170923023020) do

  create_table "ancient_ref", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                                                          null: false
    t.string   "author"
    t.string   "work"
    t.string   "link"
    t.text     "excerpt",     limit: 65535
    t.text     "excerpt_eng", limit: 65535
    t.datetime "created_at",                default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at",                default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "plant_id"
    t.index ["oa_id"], name: "index_ancient_ref_on_oa_id", unique: true, using: :btree
    t.index ["plant_id"], name: "fk_rails_200582d8e1", using: :btree
  end

  create_table "animal_compounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "compound_id"
    t.string   "animal_id"
    t.index ["animal_id"], name: "anc_ani_idx", using: :btree
    t.index ["compound_id"], name: "anc_com_idx", using: :btree
  end

  create_table "animals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                         null: false
    t.string   "scientific_name"
    t.string   "common_name"
    t.text     "description",     limit: 65535
    t.string   "reference_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["oa_id"], name: "index_animals_on_oa_id", unique: true, using: :btree
  end

  create_table "bibliography", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "publication_id"
    t.string   "sample_id"
    t.string   "chromatogram_id"
    t.string   "site_id"
    t.string   "source_id"
    t.string   "other_analysis_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["chromatogram_id"], name: "bib_chro_idx", using: :btree
    t.index ["other_analysis_id"], name: "bib_oth_idx", using: :btree
    t.index ["publication_id"], name: "fk_rails_0201e0a0cf", using: :btree
    t.index ["sample_id"], name: "bib_sam_idx", using: :btree
    t.index ["site_id"], name: "bib_sit_idx", using: :btree
    t.index ["source_id"], name: "bib_sou_idx", using: :btree
  end

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                     null: false
    t.string   "user_type"
    t.string   "document_id"
    t.string   "document_type"
    t.binary   "title",         limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id", using: :btree
    t.index ["user_id"], name: "index_bookmarks_on_user_id", using: :btree
  end

  create_table "chromatograms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                     null: false
    t.string   "file_path"
    t.text     "notes",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "compound_id"
    t.index ["compound_id"], name: "chr_com_idx", using: :btree
    t.index ["oa_id"], name: "index_chromatograms_on_oa_id", unique: true, using: :btree
    t.index ["sample_id"], name: "chr_sam_idx", using: :btree
  end

  create_table "compounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                          null: false
    t.string   "formula"
    t.float    "molecular_weight", limit: 24
    t.string   "name"
    t.boolean  "ancient"
    t.string   "dukes_url"
    t.text     "notes",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "peak_time",        limit: 24
    t.string   "nist_url"
    t.index ["oa_id"], name: "index_compounds_on_oa_id", unique: true, using: :btree
  end

  create_table "equipment", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                             null: false
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "year"
    t.string   "column_manufacturer"
    t.string   "column_model"
    t.text     "settings",            limit: 65535
    t.text     "notes",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "detector"
    t.string   "date"
    t.string   "location"
    t.string   "solvent"
    t.index ["oa_id"], name: "index_equipment_on_oa_id", unique: true, using: :btree
  end

  create_table "extractions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                         null: false
    t.string   "solvent"
    t.boolean  "buchi"
    t.boolean  "swished"
    t.boolean  "boiled_manually"
    t.text     "notes",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "date"
    t.string   "location"
    t.string   "ext_number"
    t.index ["oa_id"], name: "index_extractions_on_oa_id", unique: true, using: :btree
  end

  create_table "identifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                    null: false
    t.string   "certainty"
    t.text     "notes",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "product_id"
    t.index ["oa_id"], name: "index_identifications_on_oa_id", unique: true, using: :btree
    t.index ["product_id"], name: "ide_pro_idx", using: :btree
    t.index ["sample_id"], name: "ide_sam_idx", using: :btree
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                                                              null: false
    t.string   "image_file_path"
    t.text     "image_credit",    limit: 65535
    t.string   "source_id"
    t.string   "site_id"
    t.string   "plant_id"
    t.string   "animal_id"
    t.string   "chromatogram_id"
    t.string   "compound_id"
    t.string   "product_id"
    t.datetime "created_at",                    default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at",                    default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["animal_id"], name: "fk_rails_366e2bc661", using: :btree
    t.index ["chromatogram_id"], name: "fk_rails_7a4b838dea", using: :btree
    t.index ["compound_id"], name: "fk_rails_2e652f6bf0", using: :btree
    t.index ["oa_id"], name: "index_images_on_oa_id", unique: true, using: :btree
    t.index ["plant_id"], name: "fk_rails_d5e1aedcb5", using: :btree
    t.index ["product_id"], name: "fk_rails_bd36e75ae4", using: :btree
    t.index ["site_id"], name: "fk_rails_fc5c9b486e", using: :btree
    t.index ["source_id"], name: "fk_rails_2d27b10940", using: :btree
  end

  create_table "other_analysis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",      null: false
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oa_id"], name: "index_other_analysis_on_oa_id", unique: true, using: :btree
  end

  create_table "peaks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                           null: false
    t.integer  "peak_number"
    t.float    "retention_time",       limit: 24
    t.integer  "peak_height"
    t.integer  "peak_area"
    t.float    "peak_area_div_height", limit: 24
    t.float    "relative_abundance",   limit: 24
    t.float    "absolute_abundance",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "chromatogram_id"
    t.index ["chromatogram_id"], name: "pea_chr_idx", using: :btree
    t.index ["oa_id"], name: "index_peaks_on_oa_id", unique: true, using: :btree
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",       null: false
    t.string   "last_name"
    t.string   "first_name"
    t.string   "affiliation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["oa_id"], name: "index_people_on_oa_id", unique: true, using: :btree
  end

  create_table "plant_compounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "compound_id"
    t.string   "plant_id"
    t.index ["compound_id"], name: "plc_com_idx", using: :btree
    t.index ["plant_id"], name: "plc_pla_idx", using: :btree
  end

  create_table "plants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                         null: false
    t.string   "scientific_name"
    t.string   "common_name"
    t.text     "description",     limit: 65535
    t.string   "dukes_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["oa_id"], name: "index_plants_on_oa_id", unique: true, using: :btree
  end

  create_table "product_compounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "product_id"
    t.string   "compound_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["compound_id"], name: "prc_com_idx", using: :btree
    t.index ["product_id"], name: "prc_pro_idx", using: :btree
  end

  create_table "product_ingredients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "product_id"
    t.string   "linked_product_id"
    t.string   "plant_id"
    t.string   "animal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["animal_id"], name: "fk_rails_fc3f2d1d0b", using: :btree
    t.index ["linked_product_id"], name: "fk_rails_1b20706a42", using: :btree
    t.index ["plant_id"], name: "fk_rails_a7a3868299", using: :btree
    t.index ["product_id"], name: "fk_rails_7038dbc3b6", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",          null: false
    t.string   "name"
    t.string   "alternate_name"
    t.string   "plant_id"
    t.string   "plant_part"
    t.string   "animal_id"
    t.string   "animal_part"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["animal_id"], name: "pro_ani_idx", using: :btree
    t.index ["oa_id"], name: "index_products_on_oa_id", unique: true, using: :btree
    t.index ["plant_id"], name: "pro_pla_idx", using: :btree
  end

  create_table "publications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",        null: false
    t.string   "author"
    t.string   "title"
    t.string   "journal_name"
    t.string   "publisher"
    t.string   "year"
    t.string   "pages"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["oa_id"], name: "index_publications_on_oa_id", unique: true, using: :btree
  end

  create_table "sample_compounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "compound_id"
    t.index ["compound_id"], name: "sac_com_idx", using: :btree
    t.index ["sample_id"], name: "sac_sam_idx", using: :btree
  end

  create_table "samples", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                            null: false
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
    t.text     "notes",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site_id"
    t.string   "source_id"
    t.string   "equipment_id"
    t.string   "extraction_id"
    t.string   "chromatogram_id"
    t.string   "author_id"
    t.string   "editor_id"
    t.boolean  "vetted"
    t.string   "sample_type"
    t.integer  "sample_quality"
    t.string   "quality_notes"
    t.index ["author_id"], name: "sam_auth_idx", using: :btree
    t.index ["chromatogram_id"], name: "sam_chr_idx", using: :btree
    t.index ["editor_id"], name: "sam_ed_idx", using: :btree
    t.index ["equipment_id"], name: "sam_equ_idx", using: :btree
    t.index ["extraction_id"], name: "sam_ext_idx", using: :btree
    t.index ["oa_id"], name: "index_samples_on_oa_id", unique: true, using: :btree
    t.index ["site_id"], name: "sam_sit_idx", using: :btree
    t.index ["source_id"], name: "sam_sou_idx", using: :btree
  end

  create_table "searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.binary   "query_params", limit: 65535
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_searches_on_user_id", using: :btree
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                     null: false
    t.string   "geo_coords"
    t.string   "name"
    t.string   "project_url"
    t.text     "notes",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "director_id"
    t.string   "date"
    t.index ["director_id"], name: "sit_per_idx", using: :btree
    t.index ["oa_id"], name: "index_sites_on_oa_id", unique: true, using: :btree
  end

  create_table "sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "oa_id",                          null: false
    t.string   "coords"
    t.boolean  "soil_sample"
    t.text     "notes",            limit: 65535
    t.string   "object_condition"
    t.string   "object_type"
    t.string   "petrography"
    t.string   "object_treatment"
    t.boolean  "published"
    t.string   "object_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "petro_image"
    t.string   "date"
    t.string   "excavation_date"
    t.text     "excavation_notes", limit: 65535
    t.string   "current_location"
    t.string   "institution_id"
    t.index ["oa_id"], name: "index_sources_on_oa_id", unique: true, using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sample_id"
    t.string   "person_id"
    t.string   "extraction_id"
    t.string   "equipment_id"
    t.string   "site_id"
    t.index ["equipment_id"], name: "t_equ_idx", using: :btree
    t.index ["extraction_id"], name: "t_ext_idx", using: :btree
    t.index ["person_id"], name: "col_pea_idx", using: :btree
    t.index ["sample_id"], name: "col_sam_idx", using: :btree
    t.index ["site_id"], name: "t_sit_idx", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "guest",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "ancient_ref", "plants", primary_key: "oa_id"
  add_foreign_key "animal_compounds", "animals", primary_key: "oa_id", name: "anc_ani_id", on_delete: :cascade
  add_foreign_key "animal_compounds", "compounds", primary_key: "oa_id", name: "anc_com_id", on_delete: :cascade
  add_foreign_key "bibliography", "chromatograms", primary_key: "oa_id", name: "bib_chro_id", on_delete: :cascade
  add_foreign_key "bibliography", "other_analysis", primary_key: "oa_id", name: "bib_oth_id", on_delete: :cascade
  add_foreign_key "bibliography", "publications", primary_key: "oa_id"
  add_foreign_key "bibliography", "samples", primary_key: "oa_id", name: "bib_sam_id", on_delete: :cascade
  add_foreign_key "bibliography", "sites", primary_key: "oa_id", name: "bib_sit_id", on_delete: :cascade
  add_foreign_key "bibliography", "sources", primary_key: "oa_id", name: "bib_sou_id", on_delete: :cascade
  add_foreign_key "chromatograms", "compounds", primary_key: "oa_id", name: "chr_com_id", on_delete: :cascade
  add_foreign_key "chromatograms", "samples", primary_key: "oa_id", name: "chr_sam_id", on_delete: :cascade
  add_foreign_key "identifications", "products", primary_key: "oa_id", name: "ide_pro_id", on_delete: :cascade
  add_foreign_key "identifications", "samples", primary_key: "oa_id", name: "ide_sam_id", on_delete: :cascade
  add_foreign_key "images", "animals", primary_key: "oa_id"
  add_foreign_key "images", "chromatograms", primary_key: "oa_id"
  add_foreign_key "images", "compounds", primary_key: "oa_id"
  add_foreign_key "images", "plants", primary_key: "oa_id"
  add_foreign_key "images", "products", primary_key: "oa_id"
  add_foreign_key "images", "sites", primary_key: "oa_id"
  add_foreign_key "images", "sources", primary_key: "oa_id"
  add_foreign_key "peaks", "chromatograms", primary_key: "oa_id", name: "pea_chr_id", on_delete: :cascade
  add_foreign_key "plant_compounds", "compounds", primary_key: "oa_id", name: "plc_com_id", on_delete: :cascade
  add_foreign_key "plant_compounds", "plants", primary_key: "oa_id", name: "plc_pla_id", on_delete: :cascade
  add_foreign_key "product_compounds", "compounds", primary_key: "oa_id", name: "prc_com_id", on_delete: :cascade
  add_foreign_key "product_compounds", "products", primary_key: "oa_id", name: "prc_pro_id", on_delete: :cascade
  add_foreign_key "product_ingredients", "products", column: "linked_product_id", primary_key: "oa_id"
  add_foreign_key "product_ingredients", "products", primary_key: "oa_id"
  add_foreign_key "products", "animals", primary_key: "oa_id", name: "pro_ani_id", on_delete: :cascade
  add_foreign_key "products", "plants", primary_key: "oa_id", name: "pro_pla_id", on_delete: :cascade
  add_foreign_key "sample_compounds", "compounds", primary_key: "oa_id", name: "sac_com_id", on_delete: :cascade
  add_foreign_key "sample_compounds", "samples", primary_key: "oa_id", name: "sac_sam_id", on_delete: :cascade
  add_foreign_key "samples", "chromatograms", primary_key: "oa_id", name: "sam_chr_id", on_delete: :cascade
  add_foreign_key "samples", "equipment", primary_key: "oa_id", name: "sam_equ_id", on_delete: :cascade
  add_foreign_key "samples", "extractions", primary_key: "oa_id", name: "sam_ext_id", on_delete: :cascade
  add_foreign_key "samples", "people", column: "author_id", primary_key: "oa_id", name: "sam_auth_id", on_delete: :cascade
  add_foreign_key "samples", "people", column: "editor_id", primary_key: "oa_id", name: "sam_ed_id", on_delete: :cascade
  add_foreign_key "samples", "sites", primary_key: "oa_id", name: "sam_sit_id", on_delete: :cascade
  add_foreign_key "samples", "sources", primary_key: "oa_id", name: "sam_sou_id", on_delete: :cascade
  add_foreign_key "sites", "people", column: "director_id", primary_key: "oa_id", name: "sit_per_id", on_delete: :cascade
  add_foreign_key "teams", "equipment", primary_key: "oa_id", name: "t_equ_id", on_delete: :cascade
  add_foreign_key "teams", "extractions", primary_key: "oa_id", name: "t_ext_id", on_delete: :cascade
  add_foreign_key "teams", "people", primary_key: "oa_id", name: "col_pea_id", on_delete: :cascade
  add_foreign_key "teams", "samples", primary_key: "oa_id", name: "col_sam_id", on_delete: :cascade
  add_foreign_key "teams", "sites", primary_key: "oa_id", name: "t_sit_id", on_delete: :cascade
end
