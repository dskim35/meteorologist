require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    url="http://maps.googleapis.com/maps/api/geocode/json?address="+@street_address_without_spaces
    raw_data = open(url).read
    parsed_data = JSON.parse(raw_data)
    @lat = parsed_data["results"][0]["geometry"]["location"]["lat"].to_s
    @lng = parsed_data["results"][0]["geometry"]["location"]["lng"].to_s

    where=@lat+","+@lng
    url="https://api.darksky.net/forecast/3520d183393e4a66e9f03f2d72868309/"+where
    raw_data = open(url).read
    parsed_data = JSON.parse(raw_data)

    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
