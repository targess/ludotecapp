module BggParser
  class NewBoardgameFromIdService
    include BggParser::Connector

    def self.perform(id, name = nil)
      boardgame = get_by_id(id)
      return {} unless boardgame.present?

      boardgame[:name]       = name if name.present?
      boardgame[:publishers] = build_publishers_from_array(boardgame[:publishers])

      Boardgame.new(boardgame)
    end

    private_class_method

    def self.build_publishers_from_array(publishers)
      publishers.map { |publisher| Publisher.from_hash(publisher) }
    end
  end
end
