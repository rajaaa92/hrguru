FactoryGirl.define do
  factory :membership do
    from { Time.new(2002, 10, 1, 15, 2) }
    to { from + 1.month }
    user
    project
    role
    billable 0

    factory :membership_without_to do
      to nil
    end

    factory :membership_billable do
      billable 1
    end
  end
end

