require "rails_helper"

describe "User signs up", type: :system do
  
  before do
    visit new_user_registration_path
    create :role
    normal_user = create :role, name: "user"
    normal_user.id = 2
    normal_user.save
  end

  scenario "with valid data" do
    fill_in "user_fullname", with: "ishika"
    fill_in "user_email", with: "ishika@gmail.com"
    fill_in "user_phone_number", with: "99999999"
    fill_in "user_age", with: "22"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "Sign up"

    expect(page).to have_content("Event Booking")
  end

end