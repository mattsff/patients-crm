class TagPolicy < ApplicationPolicy
  def create?
    user.owner_or_admin?
  end

  def update?
    user.owner_or_admin?
  end

  def destroy?
    user.owner_or_admin?
  end
end
