require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @item = items(:one)
  end

  test "should destroy a item and all it's item_states" do
    id = @item.id
    @item.destroy
    assert_nil ItemState.find_by(item_id: id)
  end

  test "should not add a item if link is not unique" do
    assert_no_difference'Feed.count' do
      Item.create(link: @item.link)
    end
  end
end
