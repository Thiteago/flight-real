require 'sinatra'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'

file = File.read('./airports.json')
Data_airports = JSON.parse(file)

def getRequest(originCode, destinationCode, originDate, destinationDate)
  url = URI("https://ryanair.p.rapidapi.com/flights?origin_code=#{originCode}&destination_code=#{destinationCode}&origin_departure_date=#{originDate}&destination_departure_date=#{destinationDate}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '413af90314msh4988c726e3830cdp166bd0jsn65ad18a4b25f'
  request["X-RapidAPI-Host"] = 'ryanair.p.rapidapi.com'

  response = http.request(request)
  puts response.read_body
end

get '/' do
  erb :index
end

get '/buscar/:originCode/:destinationCode/:originDate/:destinationDate' do
  originCode = params[:originCode]
  destinationCode = params[:destinationCode]
  originDate = params[:originDate]
  destinationDate = params[:destinationDate]
  getRequest(originCode,destinationCode,originDate,destinationDate)
end