require "application_system_test_case"

class FeedsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @feed = feeds(:one)
    sign_in users(:one)
  end

  test "visiting the index" do
    visit feeds_url
  end

  test "creating a Feed" do
    visit feeds_url
    click_on "New"

    fill_in "feed_link", with: @feed.link
    click_on "Add"
  end

  test "updating a Feed" do
    # todo
  end

  test "destroying a Feed" do
    visit feed_url(@feed)
    page.accept_confirm do
      click_on "Delete", match: :first
    end

    assert_text "Feed was successfully destroyed"
  end
end
