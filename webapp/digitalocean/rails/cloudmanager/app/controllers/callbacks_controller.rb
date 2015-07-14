class CallbacksController < ApplicationController
	def digitalocean
#		puts "DIGITAL OCEAN RESPONSE-------------------------------"
#		puts request.env
#		puts "OMNIAUTH--------------------------------------------"
#		puts request.env["omniauth.auth"]
		@user = User.from_omniauth(request.env["omniauth.auth"])
		session["user"] = @user
		session["auth_data"] = request.env["omniauth.auth"]
		auth = request.env["omniauth.auth"]
		session["user_token"] = auth.credentials.token
		session["user_refresh_token"] = auth.credentials.refresh_token
		session["user_token_expires"] = auth.credentials.expires_at
		session["user_uuid"] = auth.info.uuid

#		access_token = session['user_token']

#		client = DropletKit::Client.new(access_token: access_token)
#		puts client.account.info().email

		sign_in_and_redirect @user
	end
end
