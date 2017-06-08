module BggParser
  class NewBoardgameFromIdService
    include BggParser::Connector

    def self.perform(id, name = nil)
      boardgame = get_by_id(id)
      return {} unless boardgame.present?

      boardgame[:name] = name if name.present?
      Boardgame.new(boardgame)
    end
  end
end
