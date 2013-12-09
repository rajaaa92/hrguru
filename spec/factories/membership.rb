FactoryGirl.define do
  factory :membership do
    from { Time.new(2002, 10, 31, 15, 2) }
    to { from + 1.month }
    user
    project
    role
  end
end

