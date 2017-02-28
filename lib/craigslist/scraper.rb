require 'open-uri'
require 'nokogiri'
require 'pry'

class Craigslist::Scraper

    attr_reader :current_location

    def initialize
        puts "What city are you in? (e.g. new york city, san francisco)"
        begin
            city = STDIN.gets.strip
        rescue
            city = gets.strip
        end
        establish_location(city)
    end

    def self.scrape_search_results_page(search_page_url)
        results_page = Nokogiri::HTML(open(search_page_url))
        results = results_page.css("li.result-row")

        
        results.each { |result| 
            title = result.css("a.result-title").text.downcase
            price = result.css("span.result-price").text.scan(/(\$\d+)/).first
            if price.class == Array
                price = price[0]
            end
            neighborhood = result.css("span.result-hood").text.strip
            url = result.css("a.result-title").attribute("href").value
            listing = Craigslist::Listing.find_or_create_by_hash({title: title, price: price, neighborhood: neighborhood, url: url})
            }
        
    end

    def self.scrape_craigslist_posting(posting_page_url)
        results_page = Nokogiri::HTML(open(posting_page_url))
        title = results_page.css("span#titletextonly").text
        price = results_page.css("span.postingtitletext span.price").text
        neighborhood = results_page.css("span.postingtitletext small").text.strip

        lat = results_page.css("div.viewposting").attribute("data-latitude").value
        lon = results_page.css("#map").attribute("data-longitude").value
        description_temp = results_page.css("section#postingbody").text.split(/\n/)
        description = ''
        description_temp.each { |s| 
            s.strip!
            if s.length > 1 && s != "QR Code Link to This Post"
                s += ' '
                description << s 
            end
            }


        results = {title: title, price: price, neighborhood: neighborhood, latitude: lat, longitude: lon, description: description.strip!}
        results
    end

    def change_location
        puts "In what city do you want to search? (e.g. dallas, philadelphia)"
        begin
            city = STDIN.gets.strip
        rescue
            city = gets.strip
        end

        establish_location(city)
    end

    def search
        Craigslist::Listing.clear_all
        puts "What are you searching for? (e.g. cross country skis, honda accord)"
        begin
            query = STDIN.gets.strip
        rescue
            query = gets.strip
        end

        self.class.scrape_search_results_page("#{@base_url}search/sss?query=#{query}&sort=rel")
        Craigslist::Listing.display_results
    end


    private

    def establish_location(city = 'afsdfaljfksjdlaflaskdfj')
        city.downcase!
        url = ''
        locations_page = Nokogiri::HTML(open("https://www.craigslist.org/about/sites"))
        locations = locations_page.css("div.box a")
        locations.each { |loc|
            if loc.text.include?(city)
                city = loc.text
                url = loc.attribute("href").value
            end
            }

        if url == ''
            puts "Could not establish location..."
            puts "Are you in the US or Canada? [Y / N]"
            begin
                in_the_us = STDIN.gets.strip.upcase
            rescue
                in_the_us = gets.strip.upcase
            end

            if in_the_us == "Y"
                puts "What state/province are you in? (e.g. New York, Ontario)"

            elsif in_the_us == "N"
                puts "What country are you in? (e.g. France, Egypt)"

            else
                establish_location(city)

            end

            state = gets.strip.downcase.split(' ').collect {|s| s.capitalize}.join(" ")

            states = locations_page.css("div.box h4")
            index = nil
            states.each_with_index { |s, i|
                if s.text == state
                    index = i
                end
                }


            cities_array = locations_page.css("div.box h4 + ul")[index].text.split(/\n/)
            cities = []
            cities_array.each { |c|
                c.strip!
                if c != ''
                    cities << c 
                end
                }
            cities_array = locations_page.css("div.box h4 + ul")[index]
            urls = cities_array.children.collect { |c| c.css("a")}.flatten
            urls = urls.collect {|u| u.attribute("href").value}

            if cities.length > 1
                puts "Which is the closest city? (e.g. 1, 2, etc.)"
                cities.each_with_index { |c, i|
                    puts "#{i}. #{c}"
                    }
                begin
                    index = STDIN.gets.strip.to_i
                rescue
                    index = gets.strip.to_i
                end

                if index >= cities.length
                    index = cities.length - 1
                end
            else
                index = 0
            end
            begin
                @current_location = cities[index]
                @base_url = urls[index]
            rescue
                puts "Invalid entry... Expecting integer."
                puts ""
                establish_location()
            end
        else
            @current_location = city
            @base_url = url
        end
        puts "Location found!"
        puts ""
        puts "Location: #{@current_location}"
        puts "Your Craigslist: #{@base_url}"
        puts ""
        puts "Is that correct? [Y/N]"
        begin
            done = STDIN.gets.strip.upcase
        rescue
            done = gets.strip.upcase
        end
        if done == "N" 
            establish_location()
        end

    end

    def base_url
        @base_url
    end
    def base_url=(url)
        @base_url = url
    end



end