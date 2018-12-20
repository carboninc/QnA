# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  To help the community
  As authenticated user
  I would like to be able to leave a answer
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'post answer' do
      fill_in 'Body', with: 'answer text'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'answer text'
    end

    # scenario 'asks a question with errors' do
    #   click_on 'Ask'
    #
    #   expect(page).to have_content "Title can't be blank"
    # end
  end

  # scenario 'Unauthenticated user tries to ask a question' do
  #   visit questions_path
  #   click_on 'Ask question'
  #
  #   expect(page).to have_content 'You need to sign in or sign up before continuing.'
  # end
end