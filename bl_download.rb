# coding: utf-8
require 'HTTParty'
require 'Nokogiri'

allurl = Marshal.load(File.read('bl_story_urls.mar'))

novelurl = []

allurl.each do |url|
  puts url
  page = HTTParty.get(url)
  parse_page = Nokogiri::HTML(page)
  parse_page.css('div.clear').css('a').each do | atag |
    puts atag.attr('href')
    novelurl.push(atag.attr('href'))
  end
end

File.open('blurls.mar', 'w') { |f| f.write(Marshal.dump(novelurl)) }

