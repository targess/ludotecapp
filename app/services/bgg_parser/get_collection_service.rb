module BggParser
  class GetCollectionService
    include BggParser::Connector

    def self.perform(search)
      search.present? ? get_collection(search) : []
    end
  end
end
