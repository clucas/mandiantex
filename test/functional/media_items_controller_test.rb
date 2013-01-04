require 'test_helper'

class MediaItemsControllerTest < ActionController::TestCase
  setup do
    @media_item = FactoryGirl.create(:media_item)
    # @new_media_item = FactoryGirl.build(:media_item)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_items)
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  # 
  # test "should create media_item" do
  #   assert_difference('MediaItem.count') do
  #     post :create, media_item: { unit_cost: 5 }
  #   end
  # 
  #   assert_redirected_to media_item_path(assigns(:media_item))
  # end

  test "should show media_item" do
    get :show, id: @media_item
    assert_response :success
  end

  # test "should get edit" do
  #   get :edit, id: @media_item
  #   assert_response :success
  # end
  # 
  # test "should update media_item" do
  #   put :update, id: @media_item, media_item: { author: @new_media_item.author, category: @new_media_item.category, currency: @new_media_item.currency, published_on: @new_media_item.published_on, publisher: @new_media_item.publisher, title: @new_media_item.title, unit_cost: @new_media_item.unit_cost }
  #   assert_redirected_to media_item_path(assigns(:media_item))
  # end
  # 
  # test "should destroy media_item" do
  #   assert_difference('MediaItem.count', -1) do
  #     delete :destroy, id: @media_item
  #   end
  # 
  #   assert_redirected_to media_items_path
  # end
end
