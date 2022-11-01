require "rails_helper"

describe "User signs in", type: :system do
  before do
    @user = create :user
    visit new_user_session_path
  end

  it "valid with correct credentials" do
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button "sign in"

    expect(page).to have_text "Event Booking"
    expect(page).to have_button "Logout"
  end

  it "invalid with unregistered account" do
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: @user.password
    click_button "sign in"

    expect(page).to have_no_text "Welcome back"
    expect(page).to have_no_link "Sign Out"
    expect(page).to have_button "sign in"
  end

  it "invalid with invalid password" do
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "FakePassword123"
    click_button "sign in"

    expect(page).to have_no_text "Welcome back"
    expect(page).to have_button "sign in"
    expect(page).to have_no_link "Sign Out"
  end
end