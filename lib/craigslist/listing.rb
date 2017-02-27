class Craigslist::Listing

    attr_accessor :title, :price, :neighborhood, :latitude, :longitude, :description, :url
    
    def initialize(data)
        data.each { |k,v| 
            send("#{k}=",v)
            }
    end
end