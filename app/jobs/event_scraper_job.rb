require 'nokogiri'
require 'open-uri'
require 'watir'
require 'selenium-webdriver'

class EventScraperJob < ApplicationJob
  self.queue_adapter = :sidekiq
  queue_as :default
  sidekiq_options retry: false

  rescue_from(NoMethodError) do |exception|
    puts "------------------------------------------Object is empty-------------------------------------------"
  end

  def perform(*args)
    category = []
    events_url = "https://allevents.in/ahmedabad"
    Selenium::WebDriver::Chrome::Service.driver_path = Rails.root.join( "lib", "chromedriver" ).to_s
    browser = Watir::Browser.new :chrome, options: {args: ["headless"]}
    browser.goto events_url
    doc = Nokogiri::HTML.parse(browser.html)
    anchor_list = doc.css(".sec-div").css("a")
    anchor_list.each do |a|
      category.append(a.css("div")[2].text.strip)
    end
    for i in 0..4 do
      category_events_url = "https://allevents.in/ahmedabad/#{category[i]}"
      browser.goto category_events_url
      doc = Nokogiri::HTML.parse(browser.html)
      event_link = doc.css("ul").css(".resgrid-ul").css("div")[0].css("li")[0].attributes["data-link"].value
      browser.goto event_link
      doc = Nokogiri::HTML.parse(browser.html)
      event_name = doc.css(".overlay-h1").text
      event_category = category[i]
      event_date = doc.css(".display_start_time").text.split("-")[0].strip.to_date
      event_description = doc.css(".event-description-html").text.strip.delete("\n").split.slice(0,40).join(" ")
      price = 50.0
      admin_user_id = 1
      @event=Event.create(event_name: event_name, description: event_description,event_date: event_date,price: price,admin_user_id: admin_user_id)
    end
    
  end
end
