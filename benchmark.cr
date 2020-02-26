#!/bin/crystal
require "http/client"

TOTAL = 1000
TRIGGER_URL = "http://ec2-3-92-234-158.compute-1.amazonaws.com:8080"

puts "starting benchmark..."

started = Time.utc
TOTAL.times do |i|
  response = HTTP::Client.get TRIGGER_URL
  raise "non-200 status code" unless response.status_code == 200
  raise "bad response" unless response.body.strip == "{\"message\":\"Go EC2! your request was processed!\"}"
  puts "#{i} / #{TOTAL}"
end
finished = Time.utc
elapsed = (finished - started) / TOTAL
puts "#{elapsed.seconds}s #{elapsed.milliseconds}ms"
