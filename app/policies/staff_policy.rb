class StaffPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.owner_or_admin?
  end

  def create?
    user.owner_or_admin?
  end

  def destroy?
    user.owner? && record != user
  end
end
