class AppointmentPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end

  def complete?
    update?
  end

  def cancel?
    update?
  end

  def no_show?
    user.owner_or_admin?
  end

  def destroy?
    user.owner_or_admin?
  end
end
