require "application_system_test_case"

class RecommendedFeedsTest < ApplicationSystemTestCase
  setup do
    @recommended_feed = recommended_feeds(:one)
  end

  test "visiting the index" do
    visit recommended_feeds_url
    assert_selector "h1", text: "Recommended Feeds"
  end

  test "creating a Recommended feed" do
    visit recommended_feeds_url
    click_on "New Recommended Feed"

    fill_in "Description", with: @recommended_feed.description
    fill_in "Link", with: @recommended_feed.link
    fill_in "Title", with: @recommended_feed.title
    click_on "Create Recommended feed"

    assert_text "Recommended feed was successfully created"
    click_on "Back"
  end

  test "updating a Recommended feed" do
    visit recommended_feeds_url
    click_on "Edit", match: :first

    fill_in "Description", with: @recommended_feed.description
    fill_in "Link", with: @recommended_feed.link
    fill_in "Title", with: @recommended_feed.title
    click_on "Update Recommended feed"

    assert_text "Recommended feed was successfully updated"
    click_on "Back"
  end

  test "destroying a Recommended feed" do
    visit recommended_feeds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Recommended feed was successfully destroyed"
  end
end
