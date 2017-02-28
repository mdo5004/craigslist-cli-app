class Craigslist::Listing

    attr_accessor :title, :price, :neighborhood, :latitude, :longitude, :description, :url

    @@all = []

    def initialize(data = {})
        data.each { |k,v| 
            send("#{k}=",v)
            }
    end

    def self.all
        @@all
    end
    
    
    def save
        self.class.all << self
    end

    def self.find_by_title(title)
        result = self.all.select { |listing|
            listing.title == title
            }
        result[0]
    end

    def self.find_or_create_by_title(title)
        if self.find_by_title(title) == nil
            cl = Craigslist::Listing.new({title: title})
            cl.save
            else
            cl = self.find_by_title(title)
        end
        cl
    end

    def self.find_or_create_by_hash(h)
        if h[:title] == nil
            puts "Listing must have, at least, a title."
        else
            listing = find_or_create_by_title(h[:title])
            if listing == nil
            binding.pry
            end
            h.each { |k,v| 
                listing.send("#{k}=",v)
                }
        end
    end

    def self.clear_all
        self.all.clear
    end
end