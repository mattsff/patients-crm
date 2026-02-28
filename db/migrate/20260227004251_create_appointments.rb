class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :clinic, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :status, default: 0, null: false
      t.text :notes

      t.timestamps
    end

    add_index :appointments, [:clinic_id, :starts_at]
    add_index :appointments, [:clinic_id, :status]
  end
end
