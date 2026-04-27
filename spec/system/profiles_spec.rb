require "rails_helper"

RSpec.describe "Profiles", type: :system do
  it "updates account name" do
    user = create(:user, account_name: "before")

    sign_in user, scope: :user

    visit user_path(user)

    find(".profile-header-name").click

    fill_in "user_account_name", with: "after"
    click_button "保存"

    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content("after")
  end
end