class Boardgame < ApplicationRecord
  require 'bgg'

  has_and_belongs_to_many :events
  has_many :loans

  validates :name, presence: true
  validates :maxplayers, presence: true

  def free_to_loan?
    loans.where(returned_at: nil).count.zero?
  end

  def active_loans(event)
    loans.where(returned_at:nil, event: event)
  end

  def at_event?(event)
    events.find_by(id: event)
  end

  private

    def self.bgg_search_by_name(name = "los colonos de catan")
      return [] if name.match(/^\s*$/)
      searched_boardgames = BggApi::search("query=#{name}")
      return [] unless searched_boardgames['total'].to_i > 0

      searched_boardgames['item'].map do |boardgame|
        [boardgame["id"], boardgame["name"].first["value"]]
      end
    end

    def self.bgg_get_by_id(id)
      boardgame = BggApi::thing("id=#{id}")['item']
      boardgame.first if boardgame
    end

    def self.bgg_get_collection(username)
      boardgames = BggApi::collection("username=#{username}&own=1")

      return [] unless boardgames && boardgames['totalitems'].to_i.positive?

      boardgames['item'].map do |boardgame|
        {id: boardgame["objectid"], name: boardgame["name"].first["content"]}
      end
    end

    def self.create_from_bgg_id(id, name=nil)
      boardgame = self.bgg_get_by_id(id)
      my_boardgame = Boardgame.new(
        name:        name || boardgame['name'].first['value'],
        image:       'http://'+boardgame['image'].first[2..-1],
        thumbnail:   'http://'+boardgame['thumbnail'].first[2..-1],
        description: boardgame['description'].first,
        minplayers:  boardgame['minplayers'].first['value'],
        maxplayers:  boardgame['maxplayers'].first['value'],
        playingtime: boardgame['playingtime'].first['value'],
        minage:      boardgame['minage'].first['value'],
        bgg_id:      boardgame['id'])
      my_boardgame.save
    end

    def self.import_from_bgg_collection(username)
      collection = bgg_get_collection(username)
      collection.each do |boardgame|
        create_from_bgg_id(boardgame[:id], boardgame[:name])
        sleep(0.5)
      end
    end
end
