class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.string :home_type
      t.string :room_type
      t.integer :accommodate
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :price

      t.boolean :has_tv, :default => false
      t.boolean :has_kitchen, :default => false
      t.boolean :has_internet, :default => false
      t.boolean :has_heating, :default => false
      t.boolean :has_air_condtion, :default => false
      t.boolean :is_active, :default => false

      t.timestamps
    end
  end
end
