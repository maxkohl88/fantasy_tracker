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

ActiveRecord::Schema.define(version: 20160614202216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_contracts_on_player_id", using: :btree
    t.index ["team_id"], name: "index_contracts_on_team_id", using: :btree
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.integer  "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matchups", force: :cascade do |t|
    t.integer  "week"
    t.string   "source_path"
    t.integer  "season_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["season_id"], name: "index_matchups_on_season_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "remote_id"
    t.string   "team_abbreviation"
    t.string   "position"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "results", force: :cascade do |t|
    t.string   "type"
    t.string   "interval"
    t.integer  "year"
    t.integer  "week"
    t.integer  "scoring_period"
    t.integer  "points"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "matchup_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["matchup_id"], name: "index_results_on_matchup_id", using: :btree
    t.index ["player_id"], name: "index_results_on_player_id", using: :btree
    t.index ["team_id"], name: "index_results_on_team_id", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "season_id"
    t.json     "mapping",    default: {}, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["season_id"], name: "index_schedules_on_season_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "year"
    t.integer  "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_seasons_on_league_id", using: :btree
  end

  create_table "team_matchups", force: :cascade do |t|
    t.integer "team_id"
    t.integer "matchup_id"
    t.index ["matchup_id"], name: "index_team_matchups_on_matchup_id", using: :btree
    t.index ["team_id"], name: "index_team_matchups_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "remote_id"
    t.string   "name"
    t.integer  "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_teams_on_season_id", using: :btree
  end

end
