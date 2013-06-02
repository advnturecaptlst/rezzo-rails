# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ft = GData::Client::FusionTables.new 
ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
ft.set_api_key(ENV['GOOGLE_KEY']) 

tables = ft.show_tables
rezzo  = tables.select{|t| t.name == "Rezzo"}.first

(8..10).step(0.10) do |n|
  data = [{ "Village"      => "Village in Togo",
            "Category"     => ['school', 'clinic', 'water pump'].sample,
            "Description"  => "seed data",
            "Geo"          => "<Point><coordinates>1.166667, #{n}</coordinates></Point>" }]
  rezzo.insert(data)
end