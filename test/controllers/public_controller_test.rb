require 'test_helper'

class PublicControllerTest < ActionController::TestCase
  test "should get hhme" do
    get :hhme
    assert_response :success
  end

end
