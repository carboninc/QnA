# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  To create questions and post answers
  As an unauthenticated user
  I would like to be able to register in the system
" do

  background { visit new_user_registration_path }

  scenario 'User tries to sign up' do
    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end