require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper
   
    def self.scrape_search_results_page(search_page_url)
        results_page = Nokogiri::HTML(open(search_page_url))
        results = results_page.css("li.result-row")
        
        results.each { |result| 
            
            }
    end
    
    def self.scrape_craigslist_posting(posting_page_url)
        
    end
    
end