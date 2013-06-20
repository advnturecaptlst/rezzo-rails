require 'sinatra'
require 'rubygems'
require 'bundler/setup'
require 'haml'
require 'exifr'
require 'fusion_tables'


get "/" do
  haml :new
end

post "/" do
  p params
  photo_metadata = EXIFR::JPEG.new(params[:picture][:tempfile])
  if photo_metadata.gps
    latitude = photo_metadata.gps.latitude
    longitude = photo_metadata.gps.longitude
    save_to_fusion_table(latitude, longitude, params[:resource_info])
    @message = "File Upload Successful."
  else
    @message = "This photo has no GPS Data."
  end
    haml :new
end

# {:resource_info=>{village: "", description: "", category: "" }}

post "/ios" do
  params.each do |k, v|
    data = JSON.parse(v)
    resource_info = {title: data["title"], region: data["region"], notes: data["notes"], resources: data["resources"]}
    save_to_fusion_table(data['latitude'], data['longitude'], resource_info)
  end
end

private

def save_to_fusion_table(latitude, longitude, resource_info={title: "No info", region: "no info", notes: "no info", resources: "no info" })
  ft = GData::Client::FusionTables.new
  ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
  ft.set_api_key(ENV['GOOGLE_KEY'])

  tables = ft.show_tables
  rezzo  = tables.select{|t| t.name == "Tanzania"}.first

  resource_string = stringify_resources(resource_info[:resources])
  data = [{ "Geo" => "#{latitude},#{longitude}", "Title" => resource_info[:title], "Notes" => resource_info[:notes], "Resources" => resource_string, "Region" => resource_info[:region]}]
  rezzo.insert(data)
end

def stringify_resources(resources)
  resource_string = ""
  resources.each { |k,v| resource_string << "#{v.join(';')};"}
  resource_string
end
