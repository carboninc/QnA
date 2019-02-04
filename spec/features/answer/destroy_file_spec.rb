# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete attached file', "
  Answer author
  May remove your attached file to the answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  given(:other_user) { create(:user) }
  given(:other_answer) { create(:answer, question: question, user: other_user) }


  scenario 'Unauthenticated user cannot delete attached file' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in user }

    scenario 'delete attached file from his answer' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      within "#answer-block-#{answer.id}" do
        click_on 'Edit'
        click_on 'Delete File'
        expect(page).not_to have_link 'spec_helper.rb'
      end
    end

    scenario 'cannot delete attached file if not author' do
      other_answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
