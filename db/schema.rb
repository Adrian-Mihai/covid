# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_18_185829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "population", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
  end

  create_table "disease_reports", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.date "date", null: false
    t.integer "cases"
    t.integer "tests"
    t.integer "deaths"
    t.integer "recovered"
    t.integer "intensive_care"
    t.integer "hospitalized"
    t.integer "emergency_calls"
    t.integer "information_calls"
    t.integer "home_isolation"
    t.integer "home_quarantine"
    t.integer "institutional_isolation"
    t.integer "institutional_quarantine"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_disease_reports_on_country_id"
    t.index ["date"], name: "index_disease_reports_on_date", unique: true
  end

  create_table "district_reports", force: :cascade do |t|
    t.bigint "district_id", null: false
    t.date "date", null: false
    t.integer "cases"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_district_reports_on_date", unique: true
    t.index ["district_id"], name: "index_district_reports_on_district_id"
  end

  create_table "districts", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.integer "population", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_districts_on_code", unique: true
    t.index ["country_id"], name: "index_districts_on_country_id"
  end

  create_table "overviews", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.integer "cases"
    t.integer "tests"
    t.integer "deaths"
    t.integer "recovered"
    t.integer "vaccinated"
    t.integer "side_effect"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_overviews_on_country_id"
  end

  create_table "vaccination_reports", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.date "date", null: false
    t.jsonb "vaccine", default: {}, null: false
    t.jsonb "side_effect", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_vaccination_reports_on_country_id"
    t.index ["date"], name: "index_vaccination_reports_on_date", unique: true
  end

  add_foreign_key "disease_reports", "countries"
  add_foreign_key "district_reports", "districts"
  add_foreign_key "districts", "countries"
  add_foreign_key "overviews", "countries"
  add_foreign_key "vaccination_reports", "countries"
end
