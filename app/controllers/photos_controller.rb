class PhotosController < ApplicationController
  def index
    save_to_fusion_table(100,100)
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
    ft.set_api_key(ENV['GOOGLE_KEY']) # obtained from the google api console

    # Creating a table
    # Create FT if it doesn't exist
    tables = ft.show_tables
    rezzo  = tables.select{|t| t.name == "Rezzo"}.first
    p rezzo.select

    # # Inserting rows (auto chunks every 500)
    # data = [{ "latitude"   => latitude, "longitude"  => longitude }]
    data =[{:village=>"Chicago", :category=>"", :description=>"", :latitude=>41.8781136, :longitude=>-87.666778856}]
    
    data.each_with_index do |d,i|            
      puts "https://www.googleapis.com/fusiontables/v1/query?sql=INSERT INTO 1DcX8-vvDmSQINxNX9zoetVjBnZo7tGM8LrTM57E (#{ d.keys.join(",") }) VALUES (#{ d.values.join(",") })&key=#{ENV['GOOGLE_KEY']};"
    end

    response = Faraday.post "https://www.googleapis.com/fusiontables/v1/query?sql=INSERT%20INTO%201DcX8-vvDmSQINxNX9zoetVjBnZo7tGM8LrTM57E%20(village,category,description,latitude,longitude)%20VALUES%20(Chicago,,,41.8781136,-87.666778856)&key=AIzaSyD_JUx-4hkNn5bqllP4OyninnBp-YtOPbg"
    p response
    # rezzo.insert(data)
    # my_table_id = rezzo.id
    # puts "*" * 100
    # p my_table_id
    # ft.execute "INSERT INTO #{my_table_id} (latitude, longitude) VALUES (#{latitude}, #{longitude});"
  end
end
