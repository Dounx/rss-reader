require 'test_helper'

class ItemStateTest < ActiveSupport::TestCase
  setup do
    @item_state = item_states(:one)
  end

  test "should not add a item_state if item_id and users_id is not unique" do
    assert_no_difference'ItemState.count' do
      ItemState.create(item_id: @item_state.item_id, user_id: @item_state.item_id)
    end
  end
end
