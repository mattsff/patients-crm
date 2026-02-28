class CreateClinics < ActiveRecord::Migration[8.1]
  def change
    create_table :clinics do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :phone
      t.string :email
      t.text :address
      t.string :primary_color, default: "#4F46E5"
      t.string :secondary_color, default: "#818CF8"
      t.string :timezone, default: "UTC"

      t.timestamps
    end

    add_index :clinics, :slug, unique: true
  end
end
