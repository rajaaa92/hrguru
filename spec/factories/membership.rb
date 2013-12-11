FactoryGirl.define do
  factory :membership do
    from { Time.new(2002, 10, 1, 15, 2) }
    to { from + 1.month }
    user
    project
    role

    factory :membership_with_hrguru do
      association :project, factory: :project, name: "hrguru"

      factory :membership_with_hrguru_no_to do
        to nil
      end
    end

    factory :membership_without_to do
      to nil
    end
  end
end

