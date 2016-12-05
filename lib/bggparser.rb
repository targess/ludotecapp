require 'bgg'

module BggParser
  def bgg_get_by_id(id)
    BggApi::thing("id=#{id}")['item'].first
  end

  def bgg_search_by_name(name = "los colonos de catan")
    searched_boardgames = BggApi::search("query=#{name}")['item']
    searched_boardgames.map do |boardgame|
      [boardgame["id"], boardgame["name"].first["value"]]
    end
  end

  def create_from_bgg_id(id, name=nil)
    boardgame = self.bgg_get_by_id(id)
    Boardgame.new(
      name:        name || boardgame['name'].first['value'],
      image:       boardgame['image'].first,
      thumbnail:   boardgame['thumbnail'].first,
      description: boardgame['description'].first,
      minplayers:  boardgame['minplayers'].first['value'],
      maxplayers:  boardgame['maxplayers'].first['value'],
      playingtime: boardgame['playingtime'].first['value'],
      minage:      boardgame['minage'].first['value'],
      bgg_id:      boardgame['id'])
  end

  def bgg_get_collection(username)
    boardgames = BggApi::collection("username=#{username}&own=1")['item']
    boardgames.map do |boardgame|
      [boardgame["objectid"], boardgame["name"].first["content"]]
    end
  end
end

