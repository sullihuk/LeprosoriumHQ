#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'




before do
 @posts = Post.order "created_at DESC"
end

set :database, {adapter: 'sqlite3', database: 'posts.db'}  

class Post < ActiveRecord::Base   
		validates :name, presence:true, length: {minimum: 2}
		validates :topic, presence:true, length: {minimum: 10}
end

class Comment < ActiveRecord::Base
		validates :name, presence:true, length: {minimum: 2}
		validates :comment, presence:true, length: {minimum: 10}

end



get '/' do
	erb :index	
end

get '/new' do
	erb :new 
end

post '/new' do
erb :new
end


get '/details/:post_id' do


	post_id = params[:post_id]


	erb :details
end

post '/details/:post_id' do


	

end
