class StrengthenPropertyData < ActiveRecord::Migration[6.0]
  def up
    ensure_constraint_ready_data!
    rename_column :properties, :has_air_condtion, :has_air_conditioning

    change_column :properties, :user_id, :bigint
    change_column :images, :property_id, :bigint

    change_column_null :properties, :user_id, false
    change_column_null :properties, :home_type, false
    change_column_null :properties, :room_type, false
    change_column_null :properties, :accommodate, false
    change_column_null :properties, :bedrooms, false
    change_column_null :properties, :bathrooms, false
    change_column_null :images, :property_id, false

    add_index :properties, :user_id
    add_index :properties, :is_active
    add_index :images, :property_id
    add_foreign_key :properties, :users
    add_foreign_key :images, :properties
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
          "reference type and nullability changes cannot be safely reversed"
  end

  private

  def ensure_constraint_ready_data!
    invalid_counts = {
      properties_without_users: select_value(<<~SQL).to_i,
        SELECT COUNT(*) FROM properties
        LEFT JOIN users ON users.id = properties.user_id
        WHERE properties.user_id IS NULL OR users.id IS NULL
      SQL
      images_without_properties: select_value(<<~SQL).to_i,
        SELECT COUNT(*) FROM images
        LEFT JOIN properties ON properties.id = images.property_id
        WHERE images.property_id IS NULL OR properties.id IS NULL
      SQL
      incomplete_properties: select_value(<<~SQL).to_i
        SELECT COUNT(*) FROM properties
        WHERE home_type IS NULL OR room_type IS NULL OR accommodate IS NULL
          OR bedrooms IS NULL OR bathrooms IS NULL
      SQL
    }.reject { |_name, count| count.zero? }

    return if invalid_counts.empty?

    details = invalid_counts.map { |name, count| "#{name}=#{count}" }.join(", ")
    raise StandardError,
          "Cannot strengthen property constraints; repair invalid data first (#{details})"
  end
end
