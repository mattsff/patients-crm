# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_27_012804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_events", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "clinic_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata", default: {}
    t.bigint "trackable_id", null: false
    t.string "trackable_type", null: false
    t.bigint "user_id"
    t.index ["clinic_id", "created_at"], name: "index_activity_events_on_clinic_id_and_created_at"
    t.index ["clinic_id"], name: "index_activity_events_on_clinic_id"
    t.index ["trackable_type", "trackable_id"], name: "index_activity_events_on_trackable"
    t.index ["user_id"], name: "index_activity_events_on_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "ends_at", null: false
    t.text "notes"
    t.bigint "patient_id", null: false
    t.datetime "starts_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["clinic_id", "starts_at"], name: "index_appointments_on_clinic_id_and_starts_at"
    t.index ["clinic_id", "status"], name: "index_appointments_on_clinic_id_and_status"
    t.index ["clinic_id"], name: "index_appointments_on_clinic_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "clinics", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.string "primary_color", default: "#4F46E5"
    t.string "secondary_color", default: "#818CF8"
    t.string "slug", null: false
    t.string "timezone", default: "UTC"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_clinics_on_slug", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.bigint "patient_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["clinic_id", "created_at"], name: "index_notes_on_clinic_id_and_created_at"
    t.index ["clinic_id"], name: "index_notes_on_clinic_id"
    t.index ["patient_id"], name: "index_notes_on_patient_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "patient_tags", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "tag_id", null: false
    t.index ["patient_id", "tag_id"], name: "index_patient_tags_on_patient_id_and_tag_id", unique: true
    t.index ["patient_id"], name: "index_patient_tags_on_patient_id"
    t.index ["tag_id"], name: "index_patient_tags_on_tag_id"
  end

  create_table "patients", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "email"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "email"], name: "index_patients_on_clinic_id_and_email"
    t.index ["clinic_id", "last_name", "first_name"], name: "index_patients_on_clinic_id_and_last_name_and_first_name"
    t.index ["clinic_id"], name: "index_patients_on_clinic_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.string "color", default: "#6B7280"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "name"], name: "index_tags_on_clinic_id_and_name", unique: true
    t.index ["clinic_id"], name: "index_tags_on_clinic_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "role"], name: "index_users_on_clinic_id_and_role"
    t.index ["clinic_id"], name: "index_users_on_clinic_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_events", "clinics"
  add_foreign_key "activity_events", "users"
  add_foreign_key "appointments", "clinics"
  add_foreign_key "appointments", "patients"
  add_foreign_key "appointments", "users"
  add_foreign_key "notes", "clinics"
  add_foreign_key "notes", "patients"
  add_foreign_key "notes", "users"
  add_foreign_key "patient_tags", "patients"
  add_foreign_key "patient_tags", "tags"
  add_foreign_key "patients", "clinics"
  add_foreign_key "tags", "clinics"
  add_foreign_key "users", "clinics"
end
