module BggParser
  class ImportCollectionService
    include BggParser::Connector

    def self.perform(username, organization)
      collection    = get_collection(username)
      boardgames_id = collection.map { |item| item[:id] }

      parsed_collection = get_multiple_by_id(boardgames_id)

      parsed_collection.each_with_index do |item, index|
        item[:name] = collection[index][:name] if item[:bgg_id] == collection[index][:id]
        item[:organization] = organization
        item[:publishers] = PublishersFromArrayService.perform(item[:publishers])

        Boardgame.create(item)
      end
    end

    private_class_method

    def self.build_publishers_from_array(publishers)
      publishers.map { |publisher| Publisher.from_hash(publisher) }
    end
  end
end
