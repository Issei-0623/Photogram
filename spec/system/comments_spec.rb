require "rails_helper"

RSpec.describe "Comments", type: :system, js: true do
  it "creates a comment on post detail page" do
    user = create(:user)
    post_record = create(:post)

    sign_in user, scope: :user

    visit post_path(post_record)

    fill_in "コメントを書く...", with: "system specでコメント"
    click_button "送信"

    expect(page).to have_content("system specでコメント")
    expect(page).to have_content(user.account_name)
  end
end