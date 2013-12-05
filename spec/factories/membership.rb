FactoryGirl.define do
  factory :membership do
    from { Time.new(2002, 10, 31, 15, 2) }
    to { Time.now + 2.days }
    user
    project
  end
end

