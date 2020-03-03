#!/bin/crystal
require "http/client"

TOTAL = 10000
TRIGGER_URL = "http://ec2-3-92-234-158.compute-1.amazonaws.com:8080"
#TRIGGER_URL = "http://ec2-balancer-515441468.us-east-1.elb.amazonaws.com"

puts "starting benchmark..."

started = Time.monotonic
min_local = Time.monotonic
max_local = Time.monotonic - Time.monotonic
TOTAL.times do |i|
  started_local = Time.monotonic
  response = HTTP::Client.get TRIGGER_URL
  finished_local = Time.monotonic
  elapsed_local = (finished_local - started_local)
  min_local = elapsed_local if elapsed_local.total_nanoseconds < min_local.total_nanoseconds
  max_local = elapsed_local if elapsed_local.total_nanoseconds > max_local.total_nanoseconds
  raise "non-200 status code" unless response.status_code == 200
  raise "bad response" unless response.body.strip == "{\"message\":\"Go EC2! your request was processed!\"}"
  puts "#{i} / #{TOTAL}"
end
finished = Time.monotonic
elapsed = (finished - started) / TOTAL
puts "average: #{elapsed.seconds}s #{elapsed.milliseconds}ms #{elapsed.microseconds}u"
puts "minimum: #{min_local.seconds}s #{min_local.milliseconds}ms #{min_local.microseconds}u"
puts "maximum: #{max_local.seconds}s #{max_local.milliseconds}ms #{max_local.microseconds}u"
