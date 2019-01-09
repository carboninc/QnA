# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  To help the community
  As authenticated user
  I would like to be able to leave a answer
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'post answer' do
      fill_in 'Body', with: 'answer text'
      click_on 'Post Your Answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'answer text'
    end

    scenario 'post answer with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to post answer' do
    visit question_path(question)
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end