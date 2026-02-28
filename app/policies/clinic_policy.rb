class ClinicPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user.owner?
  end
end
