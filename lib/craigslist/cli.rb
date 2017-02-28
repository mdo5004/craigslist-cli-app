require_relative "../../config/environment.rb"

class Craigslist::CLI

    def call
        start
    end
    
    def start
        puts "Thanks for using the Craigslist CLI"
        puts ""
        puts "designed by Michael David O'Connell"
        puts ""

        running = true

        cls = Craigslist::Scraper.new

        while running
            puts "-------------------------------"
            puts "Let's get searching!"
            puts ""
            puts "Enter s to Search"
            puts "Enter cl to Change Location"
            puts "Enter e to Exit"
            puts "-------------------------------"
            puts ""
            begin
                user_input = STDIN.gets.strip.downcase
            rescue
                user_input = gets.strip.downcase
            end

            case user_input
            when "s"
                cls.search
                listing = Craigslist::Listing.display_results
                if listing
                    
                    Craigslist::Scraper.scrape_craigslist_posting(listing.url)
                    listing.display_details
                end

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
    end
end