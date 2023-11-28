class ReviewPolicy < ApplicationPolicy
  attr_reader :user, :review

  def initialize(user,review)
    @user = user
    @review = review
  end

  def update?
    user.id == review.user_id
  end
  def destroy?
    update?
  end
end
