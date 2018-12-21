# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "Title#{n}"
    end

    sequence :body do |n|
      "Question Body#{n}"
    end

    trait :invalid do
      title { nil }
    end
  end
end
