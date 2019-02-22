FactoryBot.define do
  factory :comment do
    body { 'Test' }

    trait :invalid do
      body { nil }
    end
  end
end
