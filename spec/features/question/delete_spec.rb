# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', "
  If I am the author of the question
  Then I would like to be able to remove it.
  If I am not the author of the question
  It is not possible for me to delete the question.
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  given(:other_user) { create(:user) }
  given!(:other_question) { create(:question, user: other_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'delete his question' do
      expect(page).to have_content question.title

      click_on 'Delete'

      expect(page).to have_content 'Your question has been deleted.'
      expect(page).not_to have_content question.title
    end

    scenario 'trying to delete is not his question' do
      within("#question_#{other_question.id}") do
        expect(page).to have_content other_question.title
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'trying to delete question' do
      visit questions_path
      within("#question_#{question.id}") do
        expect(page).to have_content question.title
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end