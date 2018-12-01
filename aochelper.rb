#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'date'
require './version'
require './lib/aoc-client/aocclient.rb'

class AOCHelper
  include DateHelper
  def initialize
    @client = AOCClient.new "bradyaturner/adventofcode", VERSION
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
