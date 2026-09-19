class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.references :guest, null: false, foreign_key: { to_table: :users }
      t.references :property, null: false, foreign_key: true
      t.date :check_in, null: false
      t.date :check_out, null: false
      t.integer :total_price, null: false

      t.timestamps
    end

    add_index :reservations, [:property_id, :check_in, :check_out],
              name: "index_reservations_on_property_and_dates"
  end
end
