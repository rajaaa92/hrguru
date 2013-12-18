FactoryGirl.define do
  factory :role do
    name { %w(junior senior pm praktykant developer).sample }

    factory :role_invalid do
      name nil
    end
  end
end
