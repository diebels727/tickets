require 'open-uri'
require 'pry'

def scan(target_uri,timeout=5,&block)
  next_uri = URI.parse(target_uri).read
  while true do
    last_uri = next_uri
    begin
      next_uri = URI.parse(target_uri).read
      t = Time.now
      t_f = t.utc.to_f
      File.open("#{t_f}_uri.html",'w') { |f| f << next_uri }
      yield last_uri,next_uri
      sleep timeout
    rescue
      puts "BOOM! #{t_f}"
      File.open("#{Time.now.utc.to_f}_uri_page_down_event.html",'w') { |f| f << '' }
      sleep(1)
      next_uri = URI.parse(target_uri)
    end
  end
end

# target_uri = 'http://www.shmoocon.org/registration'
target_uri = 'http://localhost/~jonathanquigg/index.html'

scan(target_uri) do |last_string,next_string|
  puts "Tick."
  if (last_string != next_string)
    File.open("#{Time.now.utc.to_f}_uri_unequal_event.html",'w') { |f| f << ''}
    puts "UNEQUAL!!!!!"
  end
end
