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
    latitude = data['latitude']
    longitude = data['longitude']
    save_to_fusion_table(latitude, longitude, resource_info)
  end
end

post "/android" do
  p params
  # uploaded_io = params["picture"]
  # @filename = params[:picture][:filename]
  # file = params[:picture][:tempfile]

  # File.open("./public/#{@filename}", 'wb') do |f|
  #   f.write(file.read)
  # end

  # photo_metadata = EXIFR::JPEG.new("./public/" + @filename)
  # latitude = photo_metadata.gps.latitude
  # longitude = photo_metadata.gps.longitude
  # save_to_fusion_table(latitude, longitude)
end

private

def save_to_fusion_table(latitude, longitude, resource_info={village: "no info", description: "no info", category: "no info" })
  ft = GData::Client::FusionTables.new
  ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
  ft.set_api_key(ENV['GOOGLE_KEY'])

  tables = ft.show_tables
  rezzo  = tables.select{|t| t.name == "Testing"}.first

  data = [{ "Geo" => "#{latitude},#{longitude}", "Village" => resource_info[:village], "Description" => resource_info[:description], "Category" => resource_info[:category]}]
  rezzo.insert(data)
end
