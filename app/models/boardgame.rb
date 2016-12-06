class Boardgame < ApplicationRecord
  require 'bgg'

  validates :name, presence: true
  validates :maxplayers, presence: true



  def self.bgg_get_by_id(id)
    BggApi::thing("id=#{id}")['item'].first
  end

  def self.bgg_search_by_name(name = "los colonos de catan")
    searched_boardgames = BggApi::search("query=#{name}")['item']
    searched_boardgames.map do |boardgame|
      [boardgame["id"], boardgame["name"].first["value"]]
    end
  end

  def self.create_from_bgg_id(id, name=nil)
    boardgame = self.bgg_get_by_id(id)
    my_boardgame = Boardgame.new(
      name:        name || boardgame['name'].first['value'],
      image:       boardgame['image'].first[2..-1],
      thumbnail:   boardgame['thumbnail'].first[2..-1],
      description: boardgame['description'].first,
      minplayers:  boardgame['minplayers'].first['value'],
      maxplayers:  boardgame['maxplayers'].first['value'],
      playingtime: boardgame['playingtime'].first['value'],
      minage:      boardgame['minage'].first['value'],
      bgg_id:      boardgame['id'])
    my_boardgame.save
  end

  def self.bgg_get_collection(username)
    boardgames = BggApi::collection("username=#{username}&own=1")['item']
    boardgames.map do |boardgame|
      {id: boardgame["objectid"], name: boardgame["name"].first["content"]}
    end
  end

  def self.import_from_bgg_collection(username)
    collection = bgg_get_collection(username)
    collection.each do |boardgame|
      create_from_bgg_id(boardgame[:id], boardgame[:name])
      sleep(1)
    end
  end

end
