module SetCurrentTenant
  extend ActiveSupport::Concern

  included do
    before_action :set_current_tenant
  end

  private

  def set_current_tenant
    return unless current_user
    Current.clinic = current_user.clinic
    Current.user = current_user
  end
end
