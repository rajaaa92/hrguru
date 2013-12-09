FactoryGirl.define do
  factory :role do
    name { %w(junior senior pm praktykant developer).sample }
  end
end
