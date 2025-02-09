require "http"
require "json"
require "dotenv/load"

puts "Welcome to Umbrella! Here, we'll try to help you stay dry out there."
puts "Where are you? As in, in the world, specifically. Don't tell me the room you're in, just your approximate adress."

user_location = gets.chomp

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

hourly_data = hourly_weather.fetch("data") # for later use!!!

minutely = raw_weather.fetch("minutely")

minutely_sum = minutely.fetch("summary") 

currently_weather = raw_weather.fetch("currently")

present_time = currently_weather.fetch("time")

present_sum = "The weather will be " + minutely_sum.downcase + " for the next hour."

present_temp = "The currect temperature is " + hourly_data.at(0).fetch("temperature").to_s + " degrees."

present_report = present_temp + present_sum

rain = hourly_data.find do |hour|
hour.fetch("precipProbability") >= 0.1
end

if rain == nil
    puts "Sorry, no time of precipitation available for that location."
else
  time_at_rain = rain.fetch("time")

  time_to_rain = (time_at_rain - present_time) / 3600
  
  puts present_report

  if time_to_rain > 12
    puts "You probably won't need an umbrella today."
  else 
    if time_to_rain < 0
    puts "It might be raining currently."
    puts "You might want to carry an umbrella!"
    else puts "It might rain in " + time_to_rain.to_s + " hours."
    puts "You might want to carry an umbrella!"
    end
  end
end
