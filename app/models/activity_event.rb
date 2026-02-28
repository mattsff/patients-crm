class ActivityEvent < ApplicationRecord
  include Tenantable

  belongs_to :user, optional: true
  belongs_to :trackable, polymorphic: true

  validates :action, presence: true

  scope :recent, -> { order(created_at: :desc).limit(20) }

  def description
    case action
    when "created"
      "#{user&.full_name || 'System'} created #{trackable_type.downcase} #{trackable_name}"
    when "updated"
      "#{user&.full_name || 'System'} updated #{trackable_type.downcase} #{trackable_name}"
    when "deleted"
      "#{user&.full_name || 'System'} deleted #{trackable_type.downcase} #{metadata['name']}"
    when "status_changed"
      "#{user&.full_name || 'System'} changed appointment status to #{metadata['to']}"
    else
      "#{user&.full_name || 'System'} #{action} #{trackable_type.downcase}"
    end
  end

  private

  def trackable_name
    case trackable
    when Patient then trackable.full_name
    when Appointment then "for #{trackable.patient&.full_name}"
    when Note then "on #{trackable.patient&.full_name}"
    else trackable_type
    end
  end
end
