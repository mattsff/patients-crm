class CreatePatientTags < ActiveRecord::Migration[8.1]
  def change
    create_table :patient_tags do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end

    add_index :patient_tags, [:patient_id, :tag_id], unique: true
  end
end
