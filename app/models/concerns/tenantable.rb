module Tenantable
  extend ActiveSupport::Concern

  included do
    belongs_to :clinic
    validates :clinic_id, presence: true

    default_scope -> { where(clinic_id: Current.clinic&.id) if Current.clinic }
  end
end
