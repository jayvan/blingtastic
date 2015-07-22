#!/usr/bin/env ruby
require 'mechanize'

if ARGV.length != 2
  puts "Usage: #{__FILE__} <contest_id> <image_id>"
  exit 1
end

scores = Hash.new(0)
contest_id = ARGV[0].to_i
image_id = ARGV[1].to_i

agent = Mechanize.new

loop do
  voting_page = agent.get("http://blingee.com/competition/vote/#{contest_id}")
  left = voting_page.form_with(id: 'formVoteLeft')
  right = voting_page.form_with(id: 'formVoteRight')

  left_id = left.field_with(name: 'winning_blingee').value.to_i
  right_id = right.field_with(name: 'winning_blingee').value

  if left_id == image_id
    print '!'
    voting_page = left.click_button
  elsif right_id == image_id
    print '!'
    voting_page = right.click_button
  elsif scores[left_id] < scores[right_id]
    print '_'
    voting_page = left.click_button
  elsif scores[right_id] < scores[left_id]
    print '_'
    voting_page = right.click_button
  elsif rand < 0.5
    print '.'
    voting_page = left.click_button
  else
    print '.'
    voting_page = right.click_button
  end

  voting_page.search('.results tr').each do |result|
    result_id = result.search('a')[0].attributes['href'].value.split('/').last
    result_score = result.search('li .resultstat')[1].text.to_i
    scores[result_id] = result_score
  end

  sleep(rand())
end
