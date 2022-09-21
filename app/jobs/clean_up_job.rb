class CleanUpJob < ApplicationJob
  self.queue_adapter = :sidekiq
  queue_as :default
  sidekiq_options retry: 2, dead: false
  
  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    puts "------------------------------------------record not found-------------------------------------------"
  end

  def perform(*args)
    Event.all.each do |event|
      if event.event_date < Date.today
        event.delete
      end
    end
  end
end
