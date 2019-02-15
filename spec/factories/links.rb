FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'https://google.com' }
  end

  factory :gist_link, class: Link do
    name { 'Gist' }
    url { 'https://gist.github.com/carboninc/42673bd84ded0cfc7093dee0697bd7c4' }
  end
end
