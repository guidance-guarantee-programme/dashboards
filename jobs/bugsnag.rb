require 'bugsnag/api'

Bugsnag::Api.configure do |config|
  config.auth_token = ENV['BUGSNAG_AUTH_TOKEN']
  config.auto_paginate = true
end

SCHEDULER.every '2m', :first_in => 0 do |job|
  count = Bugsnag::Api.errors('548586727765621dd60134cb').delete_if { |error| error[:resolved] }.count

  send_event('bugsnag', { current: count })
end
