# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User tries to sign out' do
    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
