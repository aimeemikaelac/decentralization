class CloudmanagerController < ApplicationController
  before_action :authenticate_user!
  def index
	  @user = session["user"]
	  user_token = session['user_token']
	  client = DropletKit::Client.new(access_token: user_token)
	  @images = client.images.all()
	  @droplets = client.droplets.all()
	  puts "TEST-------------------------------"
	  puts @user
  end

  def new
  end
end
