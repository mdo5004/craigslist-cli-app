require 'open-uri'
require 'nokogiri'
require 'pry'

class Craigslist::Scraper

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

    end

end