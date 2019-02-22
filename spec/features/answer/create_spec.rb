# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  To help the community
  As authenticated user
  I would like to be able to leave a answer
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'post answer' do
      fill_in 'Body', with: 'answer text'
      click_on 'Post Your Answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'answer text'
    end

    scenario 'post answer with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'post answer with attached file' do
      fill_in 'Body', with: 'answer text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to post answer' do
    visit question_path(question)
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions' do
    given(:other_user) { create(:user) }
    given(:url) { 'https://google.com' }
    given(:gist_url) { 'https://gist.github.com/carboninc/42673bd84ded0cfc7093dee0697bd7c4' }

    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other_user') do
        sign_in(other_user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'answer text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        within('.nested-fields:nth-child(1)') do
          fill_in 'Link name', with: 'My Gist'
          fill_in 'Url', with: gist_url
        end

        click_on 'Add New List'

        within('.nested-fields:nth-child(2)') do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: url
        end

        click_on 'Post Your Answer'

        expect(page).to have_content 'answer text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        within '.answers' do
          expect(page).to have_content 'Test'
          expect(page).to have_link 'Google', href: url
        end
      end

      Capybara.using_session('other_user') do
        expect(page).to have_content 'answer text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        within '.answers' do
          expect(page).to have_content 'Test'
          expect(page).to have_link 'Google', href: url
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        within '.answers' do
          expect(page).to have_content 'Test'
          expect(page).to have_link 'Google', href: url
        end
      end
    end
  end
end