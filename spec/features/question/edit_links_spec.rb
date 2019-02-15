# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit links to question', "
  As the author of the attached links to the question
  I would like to be able to fix them
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Author can edit link from his question', js: true do
    sign_in user

    click_on 'Edit'
    within("#question_nested_form_#{question.id}") do
      fill_in 'Link name', with: 'Google RU'
    end
    click_on 'Save'

    visit question_path(question)

    expect(page).to have_content 'Google RU'
  end
end
