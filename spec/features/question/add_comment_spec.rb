# frozen_string_literal: true

require 'rails_helper'

feature 'Add comment to question', "
  As an authenticated user
  I want to be able comment
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user tries to create comment for question' do
    visit question_path(question)

    within '.add-question-comment' do
      expect(page).to_not have_content 'Add Comment'
    end
  end

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for question with valid attributes' do
      within '.add-question-comment' do
        fill_in 'Comment', with: 'Test'
        click_on 'Add comment'
        expect(page).to have_content 'Test'
      end
    end

    scenario 'creates comment for question with invalid attributes' do
      within '.add-question-comment' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end
end