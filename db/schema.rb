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

ActiveRecord::Schema.define(version: 20161213092936) do

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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "boardgames_events", id: false, force: :cascade do |t|
    t.integer "boardgame_id"
    t.integer "event_id"
    t.index ["boardgame_id"], name: "index_boardgames_events_on_boardgame_id"
    t.index ["event_id"], name: "index_boardgames_events_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "city"
    t.string   "province"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "loans_limits", default: 0
  end

  create_table "events_players", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "event_id"
    t.index ["event_id"], name: "index_events_players_on_event_id"
    t.index ["player_id"], name: "index_events_players_on_player_id"
  end

  create_table "loans", force: :cascade do |t|
    t.datetime "returned_at"
    t.integer  "event_id"
    t.integer  "boardgame_id"
    t.integer  "player_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["boardgame_id"], name: "index_loans_on_boardgame_id"
    t.index ["event_id"], name: "index_loans_on_event_id"
    t.index ["player_id"], name: "index_loans_on_player_id"
  end

  create_table "participants", force: :cascade do |t|
    t.boolean  "confirmed"
    t.boolean  "substitute",    default: false
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["player_id"], name: "index_participants_on_player_id"
    t.index ["tournament_id"], name: "index_participants_on_tournament_id"
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
    t.index ["boardgame_id"], name: "index_tournaments_on_boardgame_id"
    t.index ["event_id"], name: "index_tournaments_on_event_id"
  end

end
