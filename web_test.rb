require 'net/http'
Net::HTTP.start( 'www.ruby-lang.org' , 80 ) do |http|
  print ( http.get( '/en/License.txt' ).body)
end
