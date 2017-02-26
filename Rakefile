require_relative "./config/environment"

def reload!
    load_all "./lib"
end

task :console do
    puts "craigslist cli console:" 
    reload!
    Pry.start
end