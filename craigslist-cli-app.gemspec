% cat craigslist-cli-app.gemspec
Gem::Specification.new do |s|
    s.name        = 'craigslist-cli'
    s.version     = '1.0.0'
    s.date        = '2017-02-28'
    s.summary     = "A Craigslist CLI"
    s.description = "A simple CLI that can search Craigslist for you"
    s.authors     = ["Michael David O'Connell"]
    s.email       = 'michaeldavidoconnell@gmail.com'
    s.require_paths = 
    s.files       = Dir['lib/   *.rb'] + Dir['bin/*'] + Dir['[A-Z]*']
    s.homepage    ='http://github.com/mdo5004/craigslist-cli-app'
    s.license     = 'GPL-3.0'
end