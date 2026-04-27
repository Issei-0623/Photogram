require "rails_helper"

RSpec.describe "User login", type: :system do
  it "logs in a user" do
    user = create(:user, email: "test@example.com", password: "password")

    visit new_user_session_path

    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"

    click_button "LOG IN"

    expect(page).to have_current_path(posts_path)
    expect(page).to have_content("Photogram")
  end
end