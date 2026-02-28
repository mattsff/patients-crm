class NotePolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.user == user || user.owner_or_admin?
  end

  def destroy?
    record.user == user || user.owner_or_admin?
  end
end
