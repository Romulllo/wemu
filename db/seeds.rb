# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Community.destroy_all

Community.create(user_id: 1, name: 'rock', description: 'boa musica')
puts 'one community'
sleep 1
Community.create(user_id: 1, name: 'iron', description: 'boa musica')
puts 'two community'
sleep 1
Community.create(user_id: 1, name: 'legal', description: 'boa musica')
puts 'three community'
