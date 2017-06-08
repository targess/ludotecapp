module BggParser
  class ImportCollectionService
    include BggParser::Connector

    def self.perform(username, organization)
      collection = get_collection(username)
      collection.each do |item|
        boardgame = Boardgame.new(get_by_id(item[:id]))
        boardgame.organization = organization
        boardgame.name = item[:name]
        boardgame.save
        sleep(2)
      end
    end
  end
end
