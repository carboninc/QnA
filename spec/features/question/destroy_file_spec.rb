# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete attached file', "
  Question author
  May remove your attached file to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  given(:other_user) { create(:user) }
  given(:other_question) { create(:question, user: other_user) }


  scenario 'Unauthenticated user cannot delete attached file' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in user }

    scenario 'delete attached file from his question' do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit questions_path

      click_on 'Edit'
      click_on 'Delete File'
      expect(page).not_to have_link 'spec_helper.rb'
    end

    scenario 'cannot delete attached file if not author' do
      other_question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')

      visit questions_path
      expect(page).to_not have_link 'Edit'
    end
  end
end