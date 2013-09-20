class SubwayDataController < ApplicationController

  require 'net/http'

  def index
    
    orig_data = JSON.parse(Net::HTTP.get_response("developer.mbta.com", "/lib/rthr/orange.json").body)


    @bus = Net::HTTP.get_response("webservices.nextbus.com", "/service/publicXMLFeed?command=predictions&a=mbta&r=59&s=8203").body

    directions = Nokogiri::XML(@bus).xpath('//body/predictions/direction')

    if directions.size == 0 
      @bus = ["No information"]
    else
      @bus = []
      directions.each do |dir|
        @bus << dir
      end
    end

    #http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=mbta&r=59&s=8203


    result = {}

    result[:oak_grove] = to_station(to_destination(orig_data.dup, "Oak Grove"), "Downtown Crossing")
    result[:forest_hills] = to_station(to_destination(orig_data.dup, "Forest Hills"), "Wellington")



    #debugger

    @data = result
  end

  def to_destination(data, destination)
    data["TripList"]["Trips"].select{|e| e["Destination"] == destination}
  end

  def to_station(data, station)

    result = []

    data.each do |elem|
      elem["Predictions"].each do |trip| 
        seconds = trip["Seconds"].to_i
        result << seconds if trip["Stop"] == station
      end

    end

    result.sort
  end


end
