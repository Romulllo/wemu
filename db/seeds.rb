# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Comunidades...'
sleep 1
Community.destroy_all
puts 'Apagada !'

sleep 2

puts 'Usuarios...'
sleep 1
User.destroy_all
puts 'Apagado !'