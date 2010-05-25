require 'rubygems'
require 'nokogiri'
require 'open-uri'

# XPath of the Language table
# //div[@id='languages']/div[@class='popular compact']/table/tbody/tr[1]/td[1]/a

# Get a Nokogiri::HTML:Document for the page we’re interested in...

  doc = Nokogiri::HTML(open('http://github.com/suvajitgupta/Tasks/graphs/languages'))

  # Do funky things with it using Nokogiri::XML::Node methods...

#  puts doc
#  puts doc.xpath('//div[@id=\'languages\']/div[@class=\'popular compact\']/table/tr')
  ####
  # Search for nodes by xpath 
  doc.xpath('//div[@id=\'languages\']/div[@class=\'popular compact\']/table/tr').each do |tbody|
    puts tbody.xpath('./td[1]/a').text()
    puts "----------------------\n"
    # puts tbody.xpath('//tr/td[1]/a/text()')
  end


  user = "mattb"
  # //div[@id='main']/div[2][@class='site']/ul[@class='repositories']/li[1][@class='simple public fork']/h3/a
  doc = Nokogiri::HTML(open("http://github.com/#{user}/repositories"))
  
  puts "Now the repos\n\n\n"


  i = 0
  
  repos = Array.new

  doc.xpath('//div[@id=\'main\']/div[2][@class=\'site\']/ul[@class=\'repositories\']/li').each do |tbody|
    puts tbody.xpath('./h3/a').text()
    repos << tbody.xpath('./h3/a').text()
    
    # langs[i++] = tbody.xpath('./[@class=\'simple public fork\']/h3/a').text()
    puts "----------------------\n"
    # puts tbody.xpath('//tr/td[1]/a/text()')
  end
  repos