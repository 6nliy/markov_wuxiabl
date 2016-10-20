# coding: utf-8
# require 'HTTParty'
# require 'Nokogiri'
require 'capybara'
require 'capybara/poltergeist'
require 'date'
require "pry"
require 'HTTParty'
require 'Nokogiri'

Capybara.register_driver :poltergeist do |app|
 Capybara::Poltergeist::Driver.new(app, {js_errors: false, phantomjs_options: ['--load-images=no'], timeout: 60})
end
browser = Capybara::Session.new(:poltergeist)

# def get_parse(url)
#   page = HTTParty.get(url)
#   parse_page = Nokogiri::HTML(page)
#   return parse_page
# end



## test data
url = '/xiaoshuo/16421/212976.html'

#parse_page = get_parse("http://www.yanqingji.com" + url)
#parse_page.css('div#clickeye_content').text ## cannot get the entire thing, need to use phantom js

browser.visit("http://www.yanqingji.com" + url)
parse_page = Nokogiri::HTML(browser.source)
puts parse_page.css('div#clickeye_content').text
