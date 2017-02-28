require 'open-uri'
require 'nokogiri'
require 'pry'

class Craigslist::Scraper

    def initialize
        puts "What city are you in? (e.g. new york city, san francisco)"
        city = STDIN.gets.strip
        establish_location(city)

    end

    def self.scrape_search_results_page(search_page_url)
        results_page = Nokogiri::HTML(open(search_page_url))
        results = results_page.css("li.result-row")

        results_hashes = Array.new
        results.each { |result| 
            title = result.css("a.result-title").text.downcase
            price = result.css("span.result-price").text.scan(/(\$\d+)/).first
            if price.class == Array
                price = price[0]
            end
            neighborhood = result.css("span.result-hood").text.strip
            url = result.css("a.result-title").attribute("href").value
            results_hashes << {title: title, price: price, neighborhood: neighborhood, url: url}
            }
        results_hashes
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
    
    private
    
    def establish_location(city)
        url = ''
        locations_page = Nokogiri::HTML(open("https://www.craigslist.org/about/sites"))
        locations = locations_page.css("div.box a")
        locations.each { |loc|
            if loc.text.include?(city)
                url = loc.attribute("href").value
            end
            }
        
        if url == ''
            puts "Could not establish location..."
            puts "What state are you in? (e.g. Alabama, New York)"
            # establish location from state
            state = gets.strip
            locations = locations_page.css("div.box h4 + ul")
            
        end
        
    end

end