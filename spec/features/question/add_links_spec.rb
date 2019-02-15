# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/carboninc/42673bd84ded0cfc7093dee0697bd7c4' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds link when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within('#links') do
      within('.nested-fields:nth-child(1)') do
        fill_in 'Link name', with: 'My Gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Add New List'

      within('.nested-fields:nth-child(2)') do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: url
      end
    end

    click_on 'Ask'

    expect(page).to have_content 'Test'
    expect(page).to have_link 'Google', href: url
  end

  scenario 'User adds link with invalid URL when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'Error'
    fill_in 'Url', with: 'Error'

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end
end