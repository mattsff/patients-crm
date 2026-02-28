class PatientTag < ApplicationRecord
  belongs_to :patient
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :patient_id }
end
