module BggParser
  module Connector
    require "bgg"

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def search_by_name(name)
        return [] if name.match(/^\s*$/) || name.length <= 3

        searched_boardgames = BggApi.search("query=#{name}")
        return [] unless searched_boardgames["total"].to_i.positive?

        searched_boardgames["item"].map do |boardgame|
          { id: boardgame["id"], name: boardgame["name"].first["value"] }
        end
      end

      def get_by_id(id)
        boardgame = BggApi.thing("id=#{id}")["item"]&.first
        return {} unless boardgame

        { name:        boardgame["name"].first["value"],
          image:       boardgame["image"].first,
          thumbnail:   boardgame["thumbnail"].first,
          description: boardgame["description"].first,
          minplayers:  boardgame["minplayers"].first["value"],
          maxplayers:  boardgame["maxplayers"].first["value"],
          playingtime: boardgame["playingtime"].first["value"],
          minage:      boardgame["minage"].first["value"],
          bgg_id:      boardgame["id"] }
      end

      def get_collection(username)
        boardgames = BggApi.collection("username=#{username}&own=1")

        return [] unless boardgames && boardgames["totalitems"].to_i.positive?

        boardgames["item"].map do |boardgame|
          { id: boardgame["objectid"],
            name: boardgame["name"].first["content"],
            thumbnail: boardgame["thumbnail"].first }
        end
      end
    end
  end
end
