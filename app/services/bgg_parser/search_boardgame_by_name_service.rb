module BggParser
  class SearchBoardgameByNameService
    include BggParser::Connector

    def self.perform(search)
      search.present? ? search_by_name(search) : []
    end
  end
end
