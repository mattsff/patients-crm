class Clinic < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :patients, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :activity_events, dependent: :destroy

  has_one_attached :logo

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9\-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :primary_color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, allow_blank: true }
  validates :secondary_color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, allow_blank: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    return if slug.present?
    self.slug = name&.parameterize
  end
end
