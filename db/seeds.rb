# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category = { 1 => "school", 2 => "clinic", 3 => "water pump" }

ft = GData::Client::FusionTables.new 
ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
ft.set_api_key(ENV['GOOGLE_KEY']) 

tables = ft.show_tables
rezzo  = tables.select{|t| t.name == "Togo"}.first

10.times do
  code = category.keys.sample
  data = [{ "Village"       => "Wezo",
            "Category_id"   => code,
            "Category"      => category[code],
            "Description"   => "seed data",
            "Geo"           => "#{8 + (rand(1..5)/100.0)},#{1.166667 + (rand(1..5)/100.0)}" }]
  rezzo.insert(data)
end