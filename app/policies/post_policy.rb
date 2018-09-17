class PostPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
