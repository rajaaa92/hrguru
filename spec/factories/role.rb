FactoryGirl.define do
  factory :role do
    name { %w(junior senior pm praktykant developer).sample }
    billable 0

    factory :role_invalid do
      name nil
    end

    factory :role_billable do
      name { %w(senior developer).sample }
      billable 1
    end
  end
end
