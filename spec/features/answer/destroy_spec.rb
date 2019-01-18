# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', "
  If I am the author of the answer
  Then I would like to be able to remove it.
  If I am not the author of the answer
  It is not possible for me to delete the answer.
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given!(:other_user) { create(:user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User deletes your answer' do
      expect(page).to have_content answer.body
      click_on 'Delete'
      expect(page).not_to have_content answer.body
    end

    scenario 'User trying to delete is not your answer' do
      within "#answer-block-#{other_answer.id}" do
        expect(page).to have_content other_answer.body
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'trying to delete answer' do
      visit question_path(question)
      within("#answer-block-#{answer.id}") do
        expect(page).to have_content answer.body
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end