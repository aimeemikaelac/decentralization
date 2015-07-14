require 'sinatra'
require 'omniauth-digitalocean'
require 'droplet_kit'

set :bind, '0.0.0.0'

get '/' do
	#redirect '/auth/digitalocean'
	#"Hello, World!"
	erb :index
end

get '/auth/:provider/callback' do
	content_type 'text/plain'
	session['user'] = request.env['omniauth.auth'].to_hash
#	request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
	puts "----------------------------------"
	puts session['user']['provider']
	puts "----------------------------------"
	puts session['user']
	puts "----------------------------------"
#	a = "" << session['user']['provider'].to_s
#	a
	redirect '/account'
end

get '/account' do
	if session['user'].nil?
		redirect '/auth/digitalocean'
	else
		token = session['user']['credentials']['token'].to_s
		@client = DropletKit::Client.new(access_token: token)
		erb :account
	end
end

get '/createMachine' do
	token = session['user']['credentials']['token'].to_s
	@client = DropletKit::Client.new(access_token: token)
	erb :createMachine
#	'stub'
end

post '/createMachine' do
	dev_fingerprint = 'f7:19:ac:3c:ab:81:08:14:6d:a9:d5:3e:0f:fc:56:73'
	dev_public_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9LAFcXxkonD5CAXzPTtbp/zbUBmOQbRE5U4QpfK0N0+PGU7wsjoPEd2BSQRgASMIVypbW2oRvtWjMqDGo70iBh3sSnaogLIZS4Z1+8zlSZ33bSqcWFXc6ORe8F9qMiV8eKxKxei3Ix2lovxUZYsZKOR3pl4QGigotS5QaK9mdwtpZ03hLWFqh+w6dQC1pAvuwWGvEQuVLaEpXUxOarzPzhTckEva7veiW6EByvghR+/K+laLqP89oml2klPZJWVIbNLPrMYPCcTAmZIuU4UWGye6bESsUB5qPFdSXLqqtav4SyE7nhAyjxjzJAs7Bz2ZfXJfysXxBJB1DZvgLLFdd michael@SchoolComputer'

	name = params[:name]
	type = params[:type]
	region = 'sfo1'
	size = '512mb'
	image = 'ubuntu-14-04-x64'
#	ssh_keys = params[:ssh_keys]
	backups = false
	ipv6 = false
	private_networking = false
	user_data = ''

	token = session['user']['credentials']['token'].to_s
	@client = DropletKit::Client.new(access_token: token)

	keys = @client.ssh_keys.all()
	key_exists = false
	key_id = ''
	keys.each do |key|
		if key.fingerprint == dev_fingerprint
			key_id = key.id
			key_exists = true
			break
		end
	end

	if !key_exists
		dev_ssh_key = DropletKit::SSHKey.new()
		dev_ssh_key.name = 'CloudManagerKey'
		dev_ssh_key.public_key = dev_public_key
		key_response = @client.ssh_keys.create(dev_ssh_key)
		key_id = key_response.id
		puts "-------------------------"
		puts key_response
		puts "------------------------"
	end
	puts "---------------------------"
	puts key_exists
	puts key_id
	puts "---------------------------"
#	key_id.to_s
	droplet = DropletKit::Droplet.new(name: name, region: region, size: size, image: image, ipv6: false, ssh_keys: [key_id])
	droplet_response = @client.droplets.create(droplet)
	puts "--------------------------"
	puts droplet_response
	puts "--------------------------"
	droplet_response

end

get '/regions' do
	token = session['user']['credentials']['token'].to_s
	@client = DropletKit::Client.new(access_token: token)
	erb :regions
end

get '/images' do
	token = session['user']['credentials']['token'].to_s
	@client = DropletKit::Client.new(access_token: token)
	erb :images
end

get '/auth/failure' do
	content_type 'text/plain'
	request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
end

use Rack::Session::Cookie

use OmniAuth::Builder do
	provider :digitalocean, ENV["DIGITALOCEAN_APP_ID"], ENV["DIGITALOCEAN_SECRET"], scope: "read write"
end
