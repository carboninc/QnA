FactoryBot.define do
  factory :vote_up, class: Vote do
    value { 1 }
  end

  factory :vote_down, class: Vote do
    value { -1 }
  end
end