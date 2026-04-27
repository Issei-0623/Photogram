require "rails_helper"

RSpec.describe "Post details", type: :system do
  it "shows a post detail page" do
    user = create(:user)
    post_record = create(:post, user: user)

    sign_in user, scope: :user

    visit posts_path

    click_link href: post_path(post_record)

    expect(page).to have_current_path(post_path(post_record))
    expect(page).to have_content("Post")
    expect(page).to have_content(post_record.content)
  end
end