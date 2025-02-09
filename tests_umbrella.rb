require "http"
require "json"
require "dotenv/load"

user_location = "chicago"

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(maps_url).to_s

parsed_resp = JSON.parse(resp)

results = parsed_resp.fetch("results")

result = results.at(0)

geo = result.fetch("geometry")

location = geo.fetch("location")

lat = location.fetch("lat")
long = location.fetch("lng")

weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/" + lat.to_s + "," + long.to_s

weather = HTTP.get(weather_url).to_s

raw_weather = JSON.parse(weather)

hourly_weather = raw_weather.fetch("hourly")

hourly_data = hourly_weather.fetch("data")

present_temp = "The currect temperature is " + hourly_data.at(0).fetch("temperature").to_s + " degrees."

present_sum = " It will be " + hourly_data.at(0).fetch("summary").to_s + " for the next hour."
 
pp present_temp + present_sum

rain = hourly_data.find do |hour|
  hour.fetch("precipProbability") >= 0.15
  end


pp rain

if rain == nil
  pp "nilled bro!!! haha! lol"
else pp "hmm"
end
