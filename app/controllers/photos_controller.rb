class PhotosController < ApplicationController
  def index
  end

  def create
    uploaded_io = params[:picture]
    File.open(Rails.root.join('public', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    latitude = EXIFR::JPEG.new("./public/" + "#{uploaded_io.original_filename}").gps.latitude
    longitude = EXIFR::JPEG.new("./public/" + "#{uploaded_io.original_filename}").gps.longitude
  end

  
  private

  #just to test fusion table
  def save_to_fusion_table
    ft = GData::Client::FusionTables.new 
    ft.clientlogin(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASS'])
    ft.set_api_key(ENV['GOOGLE_KEY']) # obtained from the google api console
    # Creating a table
    cols = [{:name => "Sam Samskies", :type => 'string' }]

    ft.create_table "Testing2", cols
  end
end
