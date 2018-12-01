#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'date'
require './version'

class AOCHelper

  BASE_URL = "https://adventofcode.com"

  def initialize
    @data = load_private_data
  end

  def load_private_data
    JSON.parse File.read("./aoc_data.json")
  end

  def authenticated_request(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new uri
    req['Cookie'] = @data["session_cookie"]
    req['User-Agent'] = "bradyaturner/adventofcode-#{VERSION}"
    res = http.request(req)
    res.body
  end

  def get_leaderboard(year=current_year, id=@data["leaderboard_id"])
    authenticated_request "#{BASE_URL}/#{year}/leaderboard/private/view/#{id}.json"
  end

  def get_input_data(day=current_day, year=current_year)
    authenticated_request "#{BASE_URL}/#{year}/day/#{day}/input"
  end

  def current_date
    DateTime.now
  end

  def current_year
    current_date.strftime "%Y"
  end

  def current_day(padded=false)
    padded ? current_date.strftime("%d") : current_date.strftime("%-d")
  end
end

if __FILE__ == $0
  ah = AOCHelper.new
  puts ah.get_input_data
  puts ah.get_leaderboard
end
