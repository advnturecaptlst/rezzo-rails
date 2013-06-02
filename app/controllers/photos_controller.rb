class PhotosController < ApplicationController
  def index
  end

  def create
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
