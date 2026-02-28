class Appointment < ApplicationRecord
  include Tenantable

  belongs_to :patient
  belongs_to :user
  has_many :activity_events, as: :trackable, dependent: :destroy

  enum :status, { scheduled: 0, completed: 1, canceled: 2, no_show: 3 }

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ends_at_after_starts_at

  scope :upcoming, -> { where(status: :scheduled).where("starts_at > ?", Time.current).order(starts_at: :asc) }
  scope :today, -> { where(starts_at: Date.current.all_day) }
  scope :for_date, ->(date) { where(starts_at: date.all_day) }
  scope :for_week, ->(date) {
    start_of_week = date.beginning_of_week
    end_of_week = date.end_of_week
    where(starts_at: start_of_week.beginning_of_day..end_of_week.end_of_day)
  }
  scope :ordered, -> { order(starts_at: :asc) }

  def duration_minutes
    ((ends_at - starts_at) / 60).to_i
  end

  private

  def ends_at_after_starts_at
    return unless starts_at && ends_at
    errors.add(:ends_at, "must be after start time") if ends_at <= starts_at
  end
end
