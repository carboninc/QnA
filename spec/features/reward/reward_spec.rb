# frozen_string_literal: true

require 'rails_helper'
feature 'User can get a reward for the best answer', "
  As the author of the question
  I would like to reward the user for the best answer.
" do
  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:reward) { create(:reward, question: question) }

  scenario 'User get reward for best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within("#answer-block-#{answer.id}") do
      click_on 'Best answer'
      expect(page).to have_content reward.name
      expect(page).to have_css("img[src*='reward.jpg']")
    end
    visit rewards_path
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='reward.jpg']")
  end

  scenario 'Unauthenticated user cannot see rewards' do
    visit rewards_path
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
