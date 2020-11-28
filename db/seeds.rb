# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "faker"

# roles = ["User", "Biller"]
# 20.times do
#   User.create(
#     email: Faker::Internet.email,
#     password: "test",
#     name: Faker::Name.name,
#     role: roles.sample,
#   )
# end 

100.times do
  Order.create(
    user_id: rand(104..120),
    status: "Pending",
    total: rand(1...1000),
  )
end
