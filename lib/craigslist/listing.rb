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
        self.all.select { |listing|
            listing.title == title
            }
    end
    
    def self.find_or_create_by_title(title)
    end
end