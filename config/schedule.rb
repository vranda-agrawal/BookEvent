env :PATH, ENV['PATH']
set :output, "log/cron.log"

#Sets the environment to run during development mode
set :environment, "development"

every 1.day, at: '8:00 AM' do
  runner "Event.delay.reminder_sms"
end

every 1.day, at: '8:00 AM' do
  runner "EventScraperJob.perform_later"
end

every 1.day, at: '8:00 AM' do
  runner "CleanUpJob.perform_later"
end