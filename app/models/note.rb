class Note < ApplicationRecord
  include Tenantable

  belongs_to :patient
  belongs_to :user
  has_many :activity_events, as: :trackable, dependent: :destroy

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end
