require "rails_helper"
require "./spec/support/login_user.rb"

RSpec.describe "Event", type: :system do
  before do
    create(:event) 
  end
  include_context :login_user

  it "users registers in an event" do
    visit new_user_session_path
    expect(page).to have_text "Event Booking"
    click_link "See all the events"
    expect(page).to have_text "Events"
    expect(page).to have_text "XYZ"
    click_link "Click here to register at this event"
    expect(page).to have_text "Registration page"
    # fill_in "cardNumber", with: "4111111111111111"
  end

end