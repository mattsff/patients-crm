class PatientPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    user.owner_or_admin?
  end
end
