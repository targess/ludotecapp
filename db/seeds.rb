# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Boardgame.import_from_bgg_collection("targess")

Faker::Config.locale = 'es'

100.times do |i|

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

5.times do |i|

  start_date = Faker::Date.between(2.days.ago, 10.days.from_now)
  end_date   = start_date + rand(2)

  event = Event.create(
    name:         Faker::Space.moon,
    start_date:   start_date,
    end_date:     end_date,
    city:         Faker::Address.city,
    province:     Faker::Address.state,
    loans_limits:  0
    )

    rand(20..50).times do
        player = Player.all[rand(players_count)]
        event.players.push(player)
    end

    rand(30..50).times do
        boardgame = Boardgame.all[rand(boardgames_count)]
        event.boardgames.push(boardgame)
    end

    players_event_count    = event.players.count
    boardgames_event_count = event.boardgames.count

    rand(100..200).times do
        event.loans.create(
            created_at:  Faker::Time.between(start_date, start_date, :morning),
            returned_at: Faker::Time.between(start_date, start_date, :afternoon),
            player:      event.players[rand(players_event_count)],
            boardgame:   event.boardgames[rand(boardgames_event_count)]
        )
    end
end


