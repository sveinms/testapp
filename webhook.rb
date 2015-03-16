require 'rubygems'
require 'sinatra'
require 'json'

post '/log' do
  payload=params[:payload]
  alert = JSON.parse(payload)
  File.open "alerts.txt", "a" do |f|
    f.puts "#{alert['server_name']}: #{alert['title']}" 
  end
end