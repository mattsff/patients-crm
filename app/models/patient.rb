class Patient < ApplicationRecord
  include Tenantable

  has_many :appointments, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :patient_tags, dependent: :destroy
  has_many :tags, through: :patient_tags
  has_many :activity_events, as: :trackable, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  scope :search, ->(query) {
    return all if query.blank?
    where(
      "first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q OR phone ILIKE :q",
      q: "%#{sanitize_sql_like(query)}%"
    )
  }

  scope :ordered, -> { order(last_name: :asc, first_name: :asc) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def age
    return nil unless date_of_birth
    now = Date.current
    now.year - date_of_birth.year - (now.yday < date_of_birth.yday ? 1 : 0)
  end
end
