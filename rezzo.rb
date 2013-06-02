require 'sinatra'
require 'rubygems'
require 'bundler/setup'
require 'Haml'
require 'exifr'
require 'fusion_tables'


get "/" do
 haml :new
end

post "/" do
  params.each do |k, v|
    data = JSON.parse(v)
    latitude = data['latitude']
    longitude = data['longitude']
    save_to_fusion_table(latitude, longitude)
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

  def save_to_fusion_table(latitude, longitude)
    p latitude
    p longitude
    ft = GData::Client::FusionTables.new 
    ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
    ft.set_api_key(ENV['GOOGLE_KEY']) 

    tables = ft.show_tables
    rezzo  = tables.select{|t| t.name == "Togo"}.first

    data = [{ "Geo" => "#{latitude},#{longitude}", "Village" => "Disneyland" }]
    rezzo.insert(data)
  end
