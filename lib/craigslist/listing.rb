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
        if self.find_by_title(title) == []
            cl = Craigslist::Listing.new({title: title})
            cl.save
        end
        cl
    end
    
    def self.clear_all
        self.all = []
    end
end