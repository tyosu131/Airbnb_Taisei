require "test_helper"

class ImageTest < ActiveSupport::TestCase
  test "accepts supported images and rejects other attachments" do
    property = create_property(user: create_user)
    image = property.images.build
    image.img.attach(io: StringIO.new("image"), filename: "home.png", content_type: "image/png")
    assert image.valid?

    image.img.attach(io: StringIO.new("document"), filename: "notes.txt", content_type: "text/plain")
    assert_not image.valid?
    assert image.errors[:img].any?
  end
end
