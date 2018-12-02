#!/usr/bin/env ruby

require 'json'
require './version'
require './lib/aoc-client/aocclient.rb'

class AOCHelper
  include DateHelper
  def initialize
    secrets = JSON.parse File.read "aoc_data.json"
    @client = AOCClient.new "bradyaturner/adventofcode", VERSION, secrets
  end

  def get_leaderboard(year=current_year)
    @client.get_leaderboard year
  end

  def get_input_data(day=current_day, year=current_year)
    @client.get_input_data day, year
  end
end

if __FILE__ == $0
  ah = AOCHelper.new
  puts ah.get_input_data
  puts ah.get_leaderboard
end
