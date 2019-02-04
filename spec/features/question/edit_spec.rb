# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  given!(:other_user) { create(:user) }
  given!(:other_question) { create(:question, user: other_user) }
  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user

      visit questions_path
    end
    scenario 'edits his question' do
      within "#question-block-#{question.id}" do
        click_on 'Edit'
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      within "#question-block-#{question.id}" do
        click_on 'Edit'
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
      end
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      within "#question-block-#{other_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'edit a question with attached file' do
      within "#question-block-#{question.id}" do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      visit question_path(question)
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end