#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/contrib/all'
require 'sqlite3'



			def init_db

				@db = SQLite3::Database.new 'leprosorium.db'
				@db.results_as_hash = true

			end



before do
	init_db
end

configure do

	init_db

	@db.execute 'CREATE TABLE IF NOT EXISTS Posts 
	(
	"ID" INTEGER PRIMARY KEY AUTOINCREMENT, 
	"CREATED_DATE" DATE,
	"CONTENT" TEXT,
	"NAME" TEXT
	)'

	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
	(
	"ID" INTEGER PRIMARY KEY AUTOINCREMENT, 
	"CREATED_DATE" DATE,
	"CONTENT" TEXT,
	POST_ID INTEGER
	)'

end



get '/' do
	init_db
	@results = @db.execute 'select * from posts order by id desc'
	erb :index
end

get '/new' do
	erb :new 
end

post '/new' do

	init_db

	@content = params[:content]
	@commentator = params[:commentator]
	
		if @content.length <= 0 || @commentator.length < 1 
			@error = 'Type text post or your name'
			erb :new
		else
			@db.execute 'INSERT INTO Posts (CONTENT, CREATED_DATE, NAME) VALUES (?,datetime(),?)', [@content, @commentator]
			
			redirect to '/'
			@message = 'Благодарочка за ваш коммент'
		end


	#erb "you typed #{@content}"
	end

get '/details/:post_id' do


	post_id = params[:post_id]

	init_db
	results = @db.execute 'select * from posts where id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'select * from Comments where post_id = ? order by id desc', [post_id]

	erb :details
end

post '/details/:post_id' do

	init_db

	post_id = params[:post_id]
	@content = params[:content]
	
	results = @db.execute 'select * from posts where id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'select * from Comments where post_id = ? order by id desc', [post_id]

	

    	if @content.size <= 1 
			@error1 = 'Type text comment'
			erb :details
			else
			
			@db.execute 'INSERT INTO Comments (

			CONTENT, CREATED_DATE, POST_ID)
			 VALUES 
			 (?,datetime(),?
			 )', [@content, post_id]

			redirect to ('/details/' + post_id)
		end

	end
