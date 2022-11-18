require 'sinatra'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'


def getRequest(originCode, destinationCode, originDate, destinationDate)
  
  flights = File.read('./flight_lgw_dub.json')
  @data_flight = JSON.parse(flights)
  return @data_flight


  url = URI("https://ryanair.p.rapidapi.com/flights?origin_code=#{originCode}&destination_code=#{destinationCode}&origin_departure_date=#{originDate}&destination_departure_date=#{destinationDate}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '413af90314msh4988c726e3830cdp166bd0jsn65ad18a4b25f'
  request["X-RapidAPI-Host"] = 'ryanair.p.rapidapi.com'

  response = http.request(request)
  jsonResponse = JSON.parse(response.body)
  return jsonResponse
end

get '/' do
  file = File.read('./airports.json')
  @data_airports = JSON.parse(file)

  erb :index
end

get '/buscar' do
  originCode = params[:origem]
  destinationCode = params[:destino]
  originDate = params[:origem_data]
  destinationDate = params[:destino_data]
  @responseFlight = getRequest(originCode,destinationCode,originDate,destinationDate)
  erb :buscar
end