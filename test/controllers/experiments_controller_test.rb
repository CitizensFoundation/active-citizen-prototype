require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase
  test "should get match_pages" do
    get :match_pages
    assert_response :success
  end

end
