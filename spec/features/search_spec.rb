# frozen_string_literal: true

require 'sphinx_helper'

feature 'Search', "
  Like any user
  I would like to be able to use the search on the site
" do
  given!(:user) { create(:user, email: 'searchtest@qna.com') }
  given!(:question) { create(:question, user: user, title: 'searchtest') }
  given!(:answer) { create(:answer, question: question, user: user, body: 'searchtest') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'searchtest') }

  %w[Questions Answers Comments Users].each do |search_object|
    scenario "search in #{search_object}", js: true do
      ThinkingSphinx::Test.run do
        visit questions_path

        within '.search' do
          fill_in 'search_text', with: 'searchtest'
          select search_object, from: 'search_object'
          click_on 'Search'
        end

        within '.search_results' do
          expect(page).to have_content 'searchtest'
        end
      end
    end
  end

  scenario 'search in all', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within('.search') do
        fill_in 'search_text', with: 'searchtest'
        select 'All', from: 'search_object'
        click_on 'Search'
      end

      within('.search_results') do
        expect(page).to have_content(question.title)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end
    end
  end

  scenario 'search with empty query and redirect to current page' do
    ThinkingSphinx::Test.run do
      visit new_user_session_path

      within('.search') do
        fill_in 'search_text', with: ''
        select 'All', from: 'search_object'
        click_on 'Search'
      end

      expect(page).to have_content('You did not enter anything in the search bar')
    end
  end

  scenario 'search failed', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within('.search') do
        fill_in 'search_text', with: 'abracadabra'
        select 'All', from: 'search_object'
        click_on 'Search'
      end

      within('.search_results') do
        expect(page).to have_content('Nothing found.')
      end
    end
  end
end
