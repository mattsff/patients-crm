class Tag < ApplicationRecord
  include Tenantable

  has_many :patient_tags, dependent: :destroy
  has_many :patients, through: :patient_tags

  validates :name, presence: true, uniqueness: { scope: :clinic_id }
  validates :color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, allow_blank: true }

  scope :ordered, -> { order(:name) }
end
