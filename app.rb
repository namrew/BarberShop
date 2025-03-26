#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
# require 'pony'

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"user_name" TEXT,
			"user_phone" TEXT,
			"date_time" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
end

get '/' do
	# erb :welcome
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = "Something is wrong !_!"
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/welcome' do
	erb :welcome
end

get '/admin' do
	erb :admin
end

get '/diary' do
	erb :diary
end

post '/admin' do

	@login = params[:login]
	@password = params[:password]

	if @login == 'ruby' && @password == 'secret'
		@file = File.open("./public/users.txt", "r")
		erb :diary
		# @file.close

	else
		@message = "wrong login or password"
		erb :admin
	end
end

post '/visit' do

	@user_name = params[:user_name]
	@user_phone = params[:user_phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]

	hh = {
		:user_name => 'Input name',
		:user_phone => 'Input phone',
		:date_time => 'Input date & time'
	}

	# hh.each do |key, value|
	# 	if params[key] == ''
	# 		@error = hh[key]

	# 		return erb :visit
			
	# 	end
	# end

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	@thank_you = "Thank You :)"
	@dear_user = "Dear #{@user_name} !, we are awaiting Yo at #{@date_time} !"

	f = File.open("./public/users.txt", "a")
	f.write "User: #{@user_name}, phone: #{@user_phone}, barber: #{@barber}, color: #{@color}, date & time: #{@date_time}.\n"
	f.close


	db = get_db
	db.execute 'INSERT INTO 
		Users (
						user_name,
						user_phone,
						date_time,
						barber,
						color
					)
		VALUES (?, ?, ?, ?, ?)', [@user_name, @user_phone, @date_time, @barber, @color]

	# @db.close

	erb :visit
end

# post '/diary' do
# end

# Pony.mail({
#   :to => 'k.verman@mail.ru',
#   :via => :smtp,
#   :via_options => {
#     :address        => '127.0.0.1',
#     :port           => '1025',
#     # :user_name      => 'user',
#     # :password       => 'password',
#     # :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
#     :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
#   }
# })

