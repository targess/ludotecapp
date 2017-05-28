# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Boardgame.import_from_bgg_collection("targess")

def generate_organizations(amount = 1)
  amount.times do
    Organization.create(
      name: Faker::StarWars.character
    )
  end
end

def generate_players(amount = 100, organization = nil, min_age = 18, max_age = 65)
  organizations_count = Organization.count

  amount.times do
    Player.create(
      dni:           Faker::DNI.dni,
      firstname:     Faker::Name.first_name,
      lastname:      Faker::Name.last_name,
      city:          Faker::Address.city,
      province:      Faker::Address.state,
      birthday:      Faker::Date.birthday(min_age, max_age),
      email:         Faker::Internet.email,
      phone:         Faker::Number.between(600_000_000, 699_999_999),
      organizations: [organization || Organization.all[rand(organizations_count)]]
    )
  end
end

def generate_loans(event, returned = true, min_amount = 100, max_amount = 300)
  date             = event.start_date
  event_players    = event.players
  event_boardgames = event.boardgames

  rand(min_amount..max_amount).times do
    event.loans.create(
      created_at:  Faker::Time.between(date, date, :morning),
      returned_at: returned ? Faker::Time.between(date, date, :afternoon) : nil,
      player:      event_players[rand(event_players.count)],
      boardgame:   event_boardgames[rand(event_boardgames.count)]
    )
  end
end

def generate_not_returned_loans(event, min_amount = 10, max_amount = 20)
  generate_loans(event, false, min_amount, max_amount)
end

def generate_tournament(event, boardgame = nil)
  boardgame         ||= event.boardgames[rand(event.boardgames.count)]
  date                = event.start_date
  players_event_count = event.players.count

  tournament = event.tournaments.create(
    name:            Faker::Space.galaxy,
    date:            Faker::Time.between(date, date + 12.hours, :afternoon),
    max_competitors: rand(8..16),
    max_substitutes: rand(6..10),
    minage:          8,
    boardgame:       boardgame
  )
  rand(10..20).times do
    tournament.participants.create(
      player: event.players[rand(players_event_count)]
    )
  end
end

def generate_event(organization, start_date = nil, end_date = nil)
  start_date ||= Faker::Time.between(4.days.ago, 1.days.ago, :morning)
  end_date   ||= start_date + rand(2..4).days

  Event.create(
    name:         Faker::Space.moon,
    start_date:   start_date,
    end_date:     end_date,
    city:         Faker::Address.city,
    province:     Faker::Address.state,
    loans_limits: 0,
    organization: organization
  )
end

def assign_players_to_event(event, min = 50, max = 80)
  organization_players = event.organization.players
  rand(min..max).times do
    player = organization_players[rand(organization_players.count)]
    event.players.push(player)
  end
end

def assign_boardgames_to_event(event, min = 50, max = 80)
  organization_boardgames = event.organization.boardgames
  rand(min..max).times do
    boardgame = organization_boardgames[rand(organization_boardgames.count)]
    event.boardgames.push(boardgame)
  end
end

def generate_user(organization)
  User.create(
    email: "#{organization}@user.demo",
    password: "demo",
    password_confirmation: "demo",
    organization: organization,
    admin: false
  )
end

def init
  generate_organizations(2)

  generate_players(300)
  organizations_count = Organization.count

  User.create(email: "josetoscanogil@gmail.com", password: "123456", password_confirmation: "123456", admin: true, organization: Organization.first)
  Organization.all.each do |organization|
    generate_user(organization)
  end

  Boardgame.all.each do |boardgame|
    boardgame.organization = Organization.all[rand(organizations_count)]
    boardgame.save
  end

  # Events
  4.times do
    organization = Organization.all[rand(organizations_count)]
    event        = generate_event(organization)

    assign_players_to_event(event, 80, 140)
    assign_boardgames_to_event(event)
    generate_loans(event)
    generate_not_returned_loans(event, 10, 20)

    rand(2..5).times do
      generate_tournament(event)
    end
  end
end

Faker::Config.locale = "es"

init
