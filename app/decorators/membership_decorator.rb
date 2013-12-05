class MembershipDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def user_name
    user.present? ? user.name : '---'
  end
end
