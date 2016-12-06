# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = 'es'

10.times do |i|

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

5.times do |i|

  start_date = Faker::Date.between(2.days.ago, 10.days.from_now)

  events = Event.create(
    name:         Faker::Space.moon,
    start_date:   start_date,
    end_date:     start_date + rand(5),
    city:         Faker::Address.city,
    province:     Faker::Address.state
    )
end
