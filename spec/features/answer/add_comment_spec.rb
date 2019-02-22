# frozen_string_literal: true

require 'rails_helper'

feature 'Add comment to answer', "
  As an authenticated user
  I want to be able comment
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to create comment for answer' do
    visit question_path(question)

    within '.add-answer-comment' do
      expect(page).to_not have_content 'Add Comment'
    end
  end

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for answer with valid attributes' do
      within '.add-answer-comment' do
        fill_in 'Comment', with: 'Test'
        click_on 'Add comment'
        expect(page).to have_content 'Test'
      end
    end

    scenario 'creates comment for answer with invalid attributes' do
      within '.add-answer-comment' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.add-answer-comment' do
          fill_in 'Comment', with: 'Answer Comment'
          click_on 'Add comment'
          expect(page).to have_content 'Answer Comment'
        end
      end

      Capybara.using_session('guest') do
        within '.add-answer-comment' do
          expect(page).to have_content 'Answer Comment'
        end
      end
    end
  end
end