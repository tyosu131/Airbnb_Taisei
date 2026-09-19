ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: 1)

  def create_user(email: "guest@example.com")
    User.create!(email: email, password: "password123", name: "Test User")
  end

  def create_property(user:, active: true)
    Property.create!(
      user: user,
      name: "Quiet apartment",
      description: "A complete listing for tests",
      home_type: "Apartment",
      room_type: "Entire",
      accommodate: 2,
      bedrooms: 1,
      bathrooms: 1,
      price: 120,
      address: "1 Test Street",
      is_active: active
    )
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
