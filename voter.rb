#!/usr/bin/env ruby
require 'mechanize'

if ARGV.length != 2
  puts "Usage: #{__FILE__} <contest_id> <image_id>"
  exit 1
end

contest_id = ARGV[0]
image_id = ARGV[1]

agent = Mechanize.new

loop do
  voting_page = agent.get("http://blingee.com/competition/vote/#{contest_id}")
  left = voting_page.form_with(id: 'formVoteLeft')
  right = voting_page.form_with(id: 'formVoteRight')

  if left.field_with(name: 'winning_blingee').value == image_id
    print '!'
    voting_page = left.click_button
  elsif right.field_with(name: 'winning_blingee').value == image_id
    print '!'
    voting_page = right.click_button
  elsif rand < 0.5
    print '.'
    voting_page = left.click_button
  else
    print '.'
    voting_page = right.click_button
  end

  sleep(rand())
end
