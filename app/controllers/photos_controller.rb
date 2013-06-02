class PhotosController < ApplicationController
  def index
  end

  def new

  end

  def create
    uploaded_io = params[:picture]
    File.open(Rails.root.join('public', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    latitude = EXIFR::JPEG.new("./public/" + "#{uploaded_io.original_filename}").gps.latitude
    longitude = EXIFR::JPEG.new("./public/" + "#{uploaded_io.original_filename}").gps.longitude
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

    data = [{ "Latitude"   => latitude, "Longitude"  => longitude }]
    rezzo.insert(data)
  end
end
