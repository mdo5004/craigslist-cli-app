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
            puts ""
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
                user_input = "b"
                while user_input == "b"
                    user_input = 's'
                    listing = display_results
                    if listing
                        Craigslist::Scraper.scrape_craigslist_posting(listing.url)
                        listing.display_details
                    end

                    puts ""
                    puts "Enter o to Open in default browser or enter b to go back"
                    puts ""

                    begin
                        user_input = STDIN.gets.strip.downcase
                    rescue
                        user_input = gets.strip.downcase
                    end


                end
                
                if user_input == "o" && listing
                    listing.open_in_browser
                    user_input = "s"
                end
            when "cl"
                cls.establish_location()

            when "e", "exit"
                running = false
                break

            else
                puts "Invalid entry..."
                puts ""

            end
        end
    end
    
    def display_results
        input = ''
        index = 0
        while input == ''
            10.times do

                item = Craigslist::Listing.all[index]
                puts "#{index+1}. #{item.title} (#{item.price})"
                index += 1
                if index > Craigslist::Listing.all.length
                    break
                end
            end
            puts "----------------------------------------"
            puts "Press ENTER to see the next 10 results"
            puts "or enter item index to view specific result (e.g. 9)"
            puts "or enter q to end search"
            puts "----------------------------------------"            
            begin 
                input = STDIN.gets.strip
            rescue
                input = gets.strip
            end
        end
        input = input.to_i
        if input > 0 && input < Craigslist::Listing.all.length
            return Craigslist::Listing.all[input-1]
        else
            return false
        end
    end
end