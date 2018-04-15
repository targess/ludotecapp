module BggParser
  class NewBoardgameFromIdService
    include BggParser::Connector

    def self.perform(id, name = nil)
      boardgame = get_by_id(id)
      return {} unless boardgame.present?

      boardgame[:name]       = name if name.present?
      boardgame[:publishers] = build_publishers_from_array(boardgame[:publishers])
      boardgame[:designers]  = build_designers_from_array(boardgame[:designers])

      Boardgame.new(boardgame)
    end

    private_class_method

    def self.build_publishers_from_array(publishers)
      publishers.map { |publisher| Publisher.from_hash(publisher) }
    end

    def self.build_designers_from_array(designers)
      designers.map { |designer| Designer.from_hash(designer) }
    end
  end
end
