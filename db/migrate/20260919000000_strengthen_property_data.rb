class StrengthenPropertyData < ActiveRecord::Migration[6.0]
  def up
    remove_orphaned_rows
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
    remove_foreign_key :images, :properties
    remove_foreign_key :properties, :users
    remove_index :images, :property_id
    remove_index :properties, :is_active
    remove_index :properties, :user_id
    rename_column :properties, :has_air_conditioning, :has_air_condtion
  end

  private

  def remove_orphaned_rows
    execute "DELETE FROM images WHERE property_id IS NULL OR property_id NOT IN (SELECT id FROM properties)"
    execute "DELETE FROM properties WHERE user_id IS NULL OR user_id NOT IN (SELECT id FROM users)"
    execute "UPDATE properties SET home_type = 'Unspecified' WHERE home_type IS NULL"
    execute "UPDATE properties SET room_type = 'Unspecified' WHERE room_type IS NULL"
    execute "UPDATE properties SET accommodate = 1 WHERE accommodate IS NULL OR accommodate < 1"
    execute "UPDATE properties SET bedrooms = 1 WHERE bedrooms IS NULL OR bedrooms < 1"
    execute "UPDATE properties SET bathrooms = 1 WHERE bathrooms IS NULL OR bathrooms < 1"
  end
end
