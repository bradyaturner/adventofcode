#!/usr/bin/env ruby

require 'fileutils'
require './aochelper.rb'
require './solution_template.rb'

class AOCSolutionInitializer
  attr_accessor :dry_run
  def initialize(day=nil, year=nil)
    @helper = AOCHelper.new
    @day = day || @helper.current_day(true)
    @year = year || @helper.current_year
    @dry_run = false
  end

  def init_solution
    mk_proj_dir
    checkout_proj_branch
    create_solution_file
    download_input_file
  end

  def path
    "#{@year}/#{@day}"
  end

  def branch
    "#{@year}-#{@day}"
  end

  def mk_proj_dir
    puts "Making solution directory at #{path}"
    if !@dry_run
      FileUtils.mkdir_p path
    end
  end

  def checkout_proj_branch
    puts "Checking out branch #{branch}"
    if !@dry_run
      `git checkout -b #{branch}`
    end
  end

  def create_solution_file
    filepath = "#{path}/solution.rb"
    puts "Creating solution file at #{filepath}"
    if !@dry_run
      File.open(filepath, 'w') {|f| f.write create_template @day }
    end
    puts "Adding executable permission to #{filepath}"
    if !@dry_run
      FileUtils.chmod "a+x", filepath
    end
  end

  def download_input_file
    filepath = "#{path}/input.txt"
    samplefilepath = "#{path}/sampleinput.txt"
    puts "Downloading input data and saving to #{filepath}"
    puts "Creating empty file at #{samplefilepath}"
    if !@dry_run
      File.open(filepath, 'w') {|f| f.write @helper.get_input_data(@helper.current_day, @year)}
      FileUtils.touch(samplefilepath)
    end
  end
    
end

if __FILE__ == $0
  ai = AOCSolutionInitializer.new
  ai.init_solution
end
