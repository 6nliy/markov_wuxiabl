# coding: utf-8
require 'capybara'
require 'date'
require "pry"


### MAIN loop

#cur_proxy = ['--proxy=sg.proxymesh.com:31280'].sample

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

#Capybara.register_driver :poltergeist do |app|
#  Capybara::Poltergeist::Driver.new(app, {js_errors: false, phantomjs_options: ['--load-images=no'], timeout: 60})
#end
Capybara.default_driver = :selenium

browser = Capybara.current_session

browser.visit("http://www.yanqingji.com/plot/BL.html")
trs = browser.find_all("tr").select{ |tr| tr.find_all('td').length > 3 }

ancient_stories = trs.select{ |tr| tr.find_all('td')[3].text.include? "古代" }.map{ |tr| tr.find_all('td')[0].find('a')[:href] }

## how many pages are there?

max_page_link = browser.find("div.pagerNumeric").find_all('a').last
max_page_link[:href].scan(/[0-9]+/).last
