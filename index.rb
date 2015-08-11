require 'rubygems'
require 'dm-core'
require 'dm-more'
require 'stemmer'
require 'robots'
require 'open-uri'
require 'hpricot'
 
DataMapper.setup(:default, 'mysql://root:root@localhost/saush')
FRESHNESS_POLICY = 60 * 60 * 24 * 7 # 7 days
 
class Page
 include DataMapper::Resource
 
 property :id,          Serial
 property :url,         String, :length =&gt; 255
 property :title,       String, :length =&gt; 255
 has n, :locations
 has n, :words, :through =&gt; :locations
 property :created_at,  DateTime
 property :updated_at,  DateTime
 
 def self.find(url)
 page = first(:url =&gt; url)
 page = new(:url =&gt; url) if page.nil?
 return page
 end
 
 def refresh
 update_attributes({:updated_at =&gt; DateTime.parse(Time.now.to_s)})
 end
 
 def age
 (Time.now - updated_at.to_time)/60
 end
 
 def fresh?
 age &gt; FRESHNESS_POLICY ? false : true
 end
end
 
class Word
 include DataMapper::Resource
 
 property :id,         Serial
 property :stem,       String
 has n, :locations
 has n, :pages, :through =&gt; :locations
 
 def self.find(word)
 wrd = first(:stem =&gt; word)
 wrd = new(:stem =&gt; word) if wrd.nil?
 return wrd
 end
end
 
class Location
 include DataMapper::Resource
 
 property :id,         Serial
 property :position,   Integer
 
 belongs_to :word
 belongs_to :page
end
 
class String
 def words
 words = self.gsub(/[^\w\s]/,&quot;&quot;).split
 d = []
 words.each { |word| d &lt;&lt; word.downcase.stem unless (COMMON_WORDS.include?(word) or word.size &gt; 50) }
 return d
 end
 
 COMMON_WORDS = ['a','able','about','above','abroad', ...,'zero'] # truncated
end
 
DataMapper.auto_migrate! if ARGV[0] == 'reset'
