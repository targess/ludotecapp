# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Boardgame.import_from_bgg_collection("targess")

Faker::Config.locale = 'es'

200.times do |i|

  players = Player.create(
    dni:        Faker::DNI.dni,
    firstname:  Faker::Name.first_name,
    lastname:   Faker::Name.last_name,
    city:       Faker::Address.city,
    province:   Faker::Address.state,
    birthday:   Faker::Date.birthday(min_age = 18, max_age = 65),
    email:      Faker::Internet.email,
    phone:      Faker::Number.between(from = 600000000, to = 699999999)
    )
end

players_count    = Player.count
boardgames_count = Boardgame.count

2.times do |i|

  start_date = Faker::Time.between(4.days.ago, 1.days.ago, :morning)
  end_date   = start_date + rand(2..4).days

  event = Event.create(
    name:         Faker::Space.moon,
    start_date:   start_date,
    end_date:     end_date,
    city:         Faker::Address.city,
    province:     Faker::Address.state,
    loans_limits:  0
    )

    rand(80..120).times do
        player = Player.all[rand(players_count)]
        event.players.push(player)
    end

    rand(50..80).times do
        boardgame = Boardgame.all[rand(boardgames_count)]
        event.boardgames.push(boardgame)
    end

    players_event_count    = event.players.count
    boardgames_event_count = event.boardgames.count

    rand(100..300).times do
        event.loans.create(
            created_at:  Faker::Time.between(start_date, start_date, :morning),
            returned_at: Faker::Time.between(start_date, start_date, :afternoon),
            player:      event.players[rand(players_event_count)],
            boardgame:   event.boardgames[rand(boardgames_event_count)]
        )
    end
    rand(10..20).times do
        event.loans.create(
            created_at:  Faker::Time.between(start_date, start_date, :evening),
            returned_at: nil,
            player:      event.players[rand(players_event_count)],
            boardgame:   event.boardgames[rand(boardgames_event_count)]
        )
    end

    rand(2..5).times do
        tournament = event.tournaments.create(
            name:            Faker::Space.galaxy,
            date:            Faker::Time.between(start_date, start_date + 12.hours, :afternoon),
            max_competitors: rand(8..16),
            max_substitutes: rand(6..10),
            minage:          8,
            boardgame:       event.boardgames[rand(boardgames_event_count)]
        )
        rand(10..20).times do
            tournament.participants.create(
                player: event.players[rand(players_event_count)]
            )
        end
    end
end
