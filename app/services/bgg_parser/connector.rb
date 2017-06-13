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
        boardgame = BggApi.thing("id=#{id}")["item"]
        return {} unless boardgame

        parse_boardgame_fields(boardgame.first)
      end

      def get_multiple_by_id(*ids)
        boardgames = BggApi.thing("id=#{ids.join(',')}")
        return {} unless boardgames["item"]

        boardgames["item"].map { |boardgame| parse_boardgame_fields(boardgame) }
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

      private

      def parse_boardgame_fields(boardgame)
        {
          name:          boardgame["name"][0]["value"],
          image:         boardgame["image"][0],
          thumbnail:     boardgame["thumbnail"][0],
          description:   boardgame["description"][0],
          minplayers:    boardgame["minplayers"][0]["value"],
          maxplayers:    boardgame["maxplayers"][0]["value"],
          playingtime:   boardgame["playingtime"][0]["value"],
          minage:        boardgame["minage"][0]["value"],
          bgg_id:        boardgame["id"],
          yearpublished: boardgame["yearpublished"][0]["value"],
          minplaytime:   boardgame["minplaytime"][0]["value"],
          maxplaytime:   boardgame["maxplaytime"][0]["value"]
        }
      end
    end
  end
end
