# coding: utf-8
require 'capybara'
require 'date'
require "pry"
require 'HTTParty'
require 'Nokogiri'

Capybara.register_driver :poltergeist do |app|
 Capybara::Poltergeist::Driver.new(app, {js_errors: false, phantomjs_options: ['--load-images=no'], timeout: 60})
end


# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
# end
# Capybara.default_driver = :selenium

browser = Capybara.current_session

browser.visit("http://www.yanqingji.com/plot/BL.html")
max_page_link = browser.find("div.pagerNumeric").find_all('a').last
max_page = max_page_link[:href].scan(/[0-9]+/).last.to_i

def get_ancient_url(browser)
  trs = browser.find_all("tr").select{ |tr| tr.find_all('td').length > 3 }
  ancient_stories = trs.select{ |tr| tr.find_all('td')[3].text.include? "古代" }.map{ |tr| tr.find_all('td')[0].find('a')[:href] }
  return ancient_stories
end

allurl = []

(1..max_page.to_i).each do | pageid |
  begin
    puts pageid.to_s
    browser.visit("http://www.yanqingji.com/plot/BL-" + pageid.to_s + ".html")
    allurl = allurl + get_ancient_url(browser)
  rescue
    retry
  end
end

File.open('bl_story_urls.mar', 'w') { |f| f.write(Marshal.dump(allurl)) }

novelurl = []

def get_parse(url)
  page = HTTParty.get(url)
  parse_page = Nokogiri::HTML(page)
  return parse_page
end


allurl.each do |url|
  puts url
  page = HTTParty.get(url)
  parse_page = Nokogiri::HTML(page)
  parse_page.css('div.clear').css('a').each do | atag |
    puts atag.attr('href')
    novelurl.push(atag.attr('href'))
  end
end

File.open("novelurl.txt", "w+") do |f|
  f.puts(novelurl)
end
