class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.integer :property_id

      t.timestamps
    end
  end
end
