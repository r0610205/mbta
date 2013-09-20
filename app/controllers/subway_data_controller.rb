class SubwayDataController < ApplicationController

  def index
    
    orig_data = JSON.parse(Net::HTTP.get_response("developer.mbta.com", "/lib/rthr/orange.json").body)

    result = {}

    result[:oak_grove] = to_station(to_destination(orig_data.dup, "Oak Grove"), "Wellington")
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
