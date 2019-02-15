# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit links to answer', "
  As the author of the attached links to the answer
  I would like to be able to fix them
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Author can edit link from his answer', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Edit'
    within("#answer_nested_form_#{answer.id}") do
      fill_in 'Link name', with: 'Google RU'
    end
    click_on 'Save'

    expect(page).to have_content 'Google RU'
  end
end
