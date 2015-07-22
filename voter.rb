#!/usr/bin/env ruby
require 'mechanize'

if ARGV.length != 2
  puts "Usage: #{__FILE__} <contest_id> <image_id>"
  exit 1
end

current_rank = '?'
total_votes = 0
total_votes_for_target = 0
scores = Hash.new(0)
contest_id = ARGV[0].to_i
image_id = ARGV[1].to_i

agent = Mechanize.new

loop do
  voting_page = agent.get("http://blingee.com/competition/vote/#{contest_id}")
  left = voting_page.form_with(id: 'formVoteLeft')
  right = voting_page.form_with(id: 'formVoteRight')

  left_id = left.field_with(name: 'winning_blingee').value.to_i
  right_id = right.field_with(name: 'winning_blingee').value.to_i

  if left_id == image_id
    total_votes_for_target += 1
    total_votes += 1
    voting_page = left.click_button
  elsif right_id == image_id
    total_votes_for_target += 1
    total_votes += 1
    voting_page = right.click_button
  elsif scores[left_id] < scores[right_id]
    total_votes += 1
    voting_page = left.click_button
  elsif scores[right_id] < scores[left_id]
    total_votes += 1
    voting_page = right.click_button
  elsif rand < 0.5
    total_votes += 1
    voting_page = left.click_button
  else
    total_votes += 1
    voting_page = right.click_button
  end

  voting_page.search('.results tr').each do |result|
    result_id = result.search('a')[0].attributes['href'].value.split('/').last.to_i
    result_score = result.search('li .resultstat')[1].text.to_i
    scores[result_id] = result_score
    if result_id == image_id
      current_rank = result.search('li .resultstat')[0].text
    end
  end

  system "clear" or system "cls"
  puts "Current rank:            #{current_rank}"
  puts "Total votes:             #{total_votes}"
  puts "Total votes for target:  #{total_votes_for_target}"

  sleep(rand())
end
