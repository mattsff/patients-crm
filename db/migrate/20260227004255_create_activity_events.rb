class CreateActivityEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_events do |t|
      t.references :clinic, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :trackable, polymorphic: true, null: false
      t.string :action, null: false
      t.jsonb :metadata, default: {}

      t.datetime :created_at, null: false
    end

    add_index :activity_events, [:clinic_id, :created_at]
  end
end
