require "rails_helper"

RSpec.describe "Follows", type: :system do
  it "follows another user" do
    user = create(:user)
    other_user = create(:user, account_name: "other_user")

    sign_in user, scope: :user

    visit user_path(other_user)

    expect {
      click_button "Follow"
    }.to change(Relationship, :count).by(1)

    expect(page).to have_current_path(user_path(other_user))
    expect(page).to have_button("Unfollow")
  end
end