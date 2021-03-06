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

ActiveRecord::Schema.define(version: 20180415081543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boardgames", force: :cascade do |t|
    t.string   "name"
    t.string   "thumbnail"
    t.string   "image"
    t.text     "description"
    t.integer  "minplayers"
    t.integer  "maxplayers"
    t.integer  "playingtime"
    t.integer  "minage"
    t.integer  "bgg_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "barcode",         limit: 13
    t.string   "internalcode"
    t.datetime "deleted_at"
    t.integer  "organization_id"
    t.integer  "yearpublished"
    t.integer  "minplaytime"
    t.integer  "maxplaytime"
    t.index ["deleted_at"], name: "index_boardgames_on_deleted_at", using: :btree
    t.index ["organization_id"], name: "index_boardgames_on_organization_id", using: :btree
  end

  create_table "boardgames_designers", force: :cascade do |t|
    t.integer "boardgame_id"
    t.integer "designer_id"
    t.index ["boardgame_id"], name: "index_boardgames_designers_on_boardgame_id", using: :btree
    t.index ["designer_id"], name: "index_boardgames_designers_on_designer_id", using: :btree
  end

  create_table "boardgames_events", id: false, force: :cascade do |t|
    t.integer "boardgame_id"
    t.integer "event_id"
    t.index ["boardgame_id"], name: "index_boardgames_events_on_boardgame_id", using: :btree
    t.index ["event_id"], name: "index_boardgames_events_on_event_id", using: :btree
  end

  create_table "boardgames_publishers", id: false, force: :cascade do |t|
    t.integer "boardgame_id"
    t.integer "publisher_id"
    t.index ["boardgame_id"], name: "index_boardgames_publishers_on_boardgame_id", using: :btree
    t.index ["publisher_id"], name: "index_boardgames_publishers_on_publisher_id", using: :btree
  end

  create_table "designers", force: :cascade do |t|
    t.string  "name"
    t.integer "bgg_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "city"
    t.string   "province"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "loans_limits",    default: 0
    t.integer  "organization_id"
    t.index ["organization_id"], name: "index_events_on_organization_id", using: :btree
  end

  create_table "events_players", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "event_id"
    t.index ["event_id"], name: "index_events_players_on_event_id", using: :btree
    t.index ["player_id"], name: "index_events_players_on_player_id", using: :btree
  end

  create_table "loans", force: :cascade do |t|
    t.datetime "returned_at"
    t.integer  "event_id"
    t.integer  "boardgame_id"
    t.integer  "player_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["boardgame_id"], name: "index_loans_on_boardgame_id", using: :btree
    t.index ["event_id"], name: "index_loans_on_event_id", using: :btree
    t.index ["player_id"], name: "index_loans_on_player_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations_players", id: false, force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "player_id",       null: false
  end

  create_table "participants", force: :cascade do |t|
    t.boolean  "confirmed",     default: false
    t.boolean  "substitute",    default: false
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["player_id"], name: "index_participants_on_player_id", using: :btree
    t.index ["tournament_id"], name: "index_participants_on_tournament_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "dni"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "city"
    t.string   "province"
    t.date     "birthday"
    t.string   "email"
    t.integer  "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_players_on_deleted_at", using: :btree
  end

  create_table "publishers", force: :cascade do |t|
    t.string  "name"
    t.integer "bgg_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_substitutes"
    t.integer  "max_competitors"
    t.datetime "date"
    t.integer  "minage"
    t.integer  "boardgame_id"
    t.integer  "event_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["boardgame_id"], name: "index_tournaments_on_boardgame_id", using: :btree
    t.index ["event_id"], name: "index_tournaments_on_event_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
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
    t.integer  "organization_id"
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["organization_id"], name: "index_users_on_organization_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "boardgames", "organizations"
  add_foreign_key "events", "organizations"
  add_foreign_key "participants", "players"
  add_foreign_key "participants", "tournaments"
  add_foreign_key "tournaments", "boardgames"
  add_foreign_key "tournaments", "events"
  add_foreign_key "users", "organizations"
end
