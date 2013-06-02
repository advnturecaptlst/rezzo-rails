class PhotosController < ApplicationController
  def index
  end

  def create
    uploaded_io = params[:picture]
    File.open(Rails.root.join('public', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    photo_metadata = EXIFR::JPEG.new("./public/" + "#{uploaded_io.original_filename}")
    latitude = photo_metadata.gps.latitude
    longitude = photo_metadata.gps.longitude
    save_to_fusion_table(latitude, longitude)
  end

  
  private

  #just to test fusion table
  def save_to_fusion_table(latitude, longitude)
    ft = GData::Client::FusionTables.new 
    ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
    ft.set_api_key(ENV['GOOGLE_KEY']) 

    tables = ft.show_tables
    rezzo  = tables.select{|t| t.name == "Rezzo"}.first

    data = [{ "Geo" => "<Point><coordinates>#{latitude},#{longitude},0.0</coordinates><Point>" }]
    rezzo.insert(data)
  end
end
