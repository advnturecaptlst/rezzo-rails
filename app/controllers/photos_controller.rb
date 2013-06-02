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
  end
end
