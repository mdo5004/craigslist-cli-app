#!/usr/bin/env ruby

require_relative "../config/environment.rb"

puts "Thanks for using the Craigslist CLI"
puts ""

running = true

cls = Craigslist::Scraper.new

while running
    puts "Let's get searching!"
    puts ""
    puts "Enter s to Search"
    puts "Enter cl to Change Location"
    puts "Enter e to Exit"
    begin
        user_input = STDIN.gets.strip.downcase
    rescue
        user_input = gets.strip.downcase
    end

    case user_input
    when "s"
        cls.search

    when "cl"
        cls.establish_location()

    when "e"
        running = false
        break

    else
        puts "Invalid entry..."
        puts ""

    end
end