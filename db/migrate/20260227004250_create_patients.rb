class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients do |t|
      t.references :clinic, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.date :date_of_birth

      t.timestamps
    end

    add_index :patients, [:clinic_id, :email]
    add_index :patients, [:clinic_id, :last_name, :first_name]
  end
end
