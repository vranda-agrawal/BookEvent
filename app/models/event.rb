class Event < ApplicationRecord
  belongs_to :admin_user
  has_many :enrols, dependent: :destroy
  has_many :users, :through => :enrols
  has_many :transactions
  scope :next_day_event, -> { where(event_date: Date.tomorrow) }

  def registration_sms(user)
    puts "------------------------------------------------sending sms------------------------------------------------------"
    to = user.phone_number
    body = "Hey, you have successfully enrolled to our #{event_name} event"
    # Event.send_sms(to,body)
  end

  def self.reminder_sms
    Event.next_day_event.each do |event|
      event.users.each do |user|
        to = user.phone_number
        body = "Hey, #{user.fullname} tomorrow you have #{event.event_name} event, to attend .We are looking forward to meet you their"
        # send_sms(to,body)
      end
    end
  end

  def self.send_sms(to,body)
    client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]) 
    client.messages.create(
    from: ENV["TWILIO_NUMBER"],
    to: to,
    body: body
    )
  end

end
