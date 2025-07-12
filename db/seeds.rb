# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

SiteConfig.find_or_create_by(id: 1) do |config|
  config.instagram_text = 'Follow @nao2bs'
  config.instagram_link = 'https://instagram.com/nao2bs'
end
