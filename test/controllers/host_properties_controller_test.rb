require "test_helper"

class HostPropertiesControllerTest < ActionDispatch::IntegrationTest
  test "redirects anonymous users to sign in" do
    get host_properties_path

    assert_redirected_to new_user_session_path
  end

  test "a host cannot update another host's property" do
    owner = create_user(email: "owner@example.com")
    intruder = create_user(email: "intruder@example.com")
    property = create_property(user: owner)
    sign_in intruder

    patch host_property_path(property), params: { property: { name: "Taken over" } }

    assert_response :not_found
    assert_equal "Quiet apartment", property.reload.name
  end
end
