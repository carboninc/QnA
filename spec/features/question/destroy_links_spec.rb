# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links from question', "
  As the author of the question
  I would like to be able to remove links from the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  given(:other_user) { create(:user) }
  given(:other_question) { create(:question, user: other_user) }
  given!(:gist_link) { create(:gist_link, linkable: other_question) }

  scenario 'Unauthenticated user cannot delete link' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete Link'
  end

  describe 'Authenticated user tries', js: true do
    background { sign_in user }

    scenario 'delete link from his question' do
      visit question_path(question)
      expect(page).to have_link 'Google'
      click_on 'Delete Link'
      expect(page).not_to have_link 'Google'
    end

    scenario 'delete link from not his question' do
      visit question_path(other_question)
      within(".link-#{gist_link.id}") do
        expect(page).not_to have_link 'Delete Link'
      end
    end
  end
end
