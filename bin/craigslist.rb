#!/usr/bin/env ruby

require_relative "../config/environment.rb"

puts "Thanks for using the Craigslist CLI"
puts ""

cls = Craigslist::Scraper.new

puts "Let's get searching!"
puts ""
cls.search