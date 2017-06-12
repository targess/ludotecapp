module BggParser
  class ImportCollectionService
    include BggParser::Connector

    def self.perform(username, organization)
      collection    = get_collection(username)
      boardgames_id = collection.map { |item| item[:id] }

      parsed_collection = get_multiple_by_id(boardgames_id)

      parsed_collection.each_with_index do |item, index|
        item[:name] = collection[index][:name] if item[:bgg_id] == collection[index][:id]
        boardgame = Boardgame.new(item)
        boardgame.organization = organization
        boardgame.save
      end
    end
  end
end
