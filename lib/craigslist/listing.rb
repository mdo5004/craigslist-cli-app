require 'launchy'

class Craigslist::Listing

    attr_accessor :title, :price, :neighborhood, :latitude, :longitude, :description, :url, :age, :pid, :repost_of

    @@all = []

    def initialize(data = {})
        data.each { |k,v| 
            send("#{k}=",v)
            }
    end

    def self.all
        @@all
    end

    #    def self.remove_reposts
    #        repeats = []
    #        self.all.each_with_index {|item, i|
    #            if self.all.any? { |other_item|
    #                item.pid == other_item.repost_of 
    #                }
    #
    #                repeats << i
    #            end
    #            }
    #        binding.pry
    #
    #        repeats.reverse.each {|i| self.all.delete_at(i) }
    #        return nil
    #    end

    def save
        self.class.all << self
    end

    def self.find_by_pid(pid)
        result = self.all.select { |listing|
            listing.pid == pid
            }
        result[0]
    end

    def self.find_or_create_by_pid(pid)
        if self.find_by_pid(pid) == nil
            cl = Craigslist::Listing.new({pid: pid})
            cl.save
        else
            cl = self.find_by_pid(pid)
        end
        cl
    end

    def self.find_or_create_by_hash(h)
        if h[:pid] == nil
            puts "Listing must have a pid."
        else
            listing = find_or_create_by_pid(h[:pid])

            h.each { |k,v| 
                if !listing.instance_variable_get("@#{k}")
                    listing.send("#{k}=",v)
                end
                }
        end
    end

    def self.clear_all
        self.all.clear
    end

    def open_in_browser
        Launchy.open("#{Craigslist::Scraper.base_url}#{@url}")
    end


end