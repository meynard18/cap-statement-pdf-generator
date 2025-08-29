require "test_helper"

class CapabilityStatementsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get capability_statements_new_url
    assert_response :success
  end

  test "should get create" do
    get capability_statements_create_url
    assert_response :success
  end

  test "should get show" do
    get capability_statements_show_url
    assert_response :success
  end
end
