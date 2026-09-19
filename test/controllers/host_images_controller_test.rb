require "test_helper"

class HostImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = create_user(email: "image-owner@example.com")
    @intruder = create_user(email: "image-intruder@example.com")
    @property = create_property(user: @owner)
    sign_in @intruder
  end

  test "a host cannot add images to another host's property" do
    assert_no_difference "Image.count" do
      post host_property_images_path(@property), params: { images: ["untrusted upload"] }
    end

    assert_response :not_found
  end

  test "a host cannot delete images from another host's property" do
    image = @property.images.create!

    assert_no_difference "Image.count" do
      delete host_property_image_path(@property, image)
    end

    assert_response :not_found
    assert Image.exists?(image.id)
  end
end
