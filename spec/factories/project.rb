FactoryGirl.define do
  factory :project do
    name { Faker::Internet.domain_word }
  end

  factory :invalid_project, class: Project do
    name nil
  end
end
