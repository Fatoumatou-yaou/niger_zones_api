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

ActiveRecord::Schema[8.0].define(version: 2024_12_03_095956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "communes", force: :cascade do |t|
    t.string "name"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commune_code"
    t.index ["department_id"], name: "index_communes_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "department_code"
    t.index ["region_id"], name: "index_departments_on_region_id"
  end

  create_table "localites", force: :cascade do |t|
    t.string "name"
    t.bigint "commune_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "population_totale"
    t.integer "homme"
    t.integer "femme"
    t.integer "menage"
    t.float "long_degre"
    t.float "lat_degre"
    t.string "localite_code"
    t.string "localite_num"
    t.integer "milieu"
    t.integer "menageagricole"
    t.integer "typelocalite"
    t.index ["commune_id"], name: "index_localites_on_commune_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region_code"
  end

  add_foreign_key "communes", "departments"
  add_foreign_key "departments", "regions"
  add_foreign_key "localites", "communes"
end
