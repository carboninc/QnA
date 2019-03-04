# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe on question', "
  As an authenticated user
  I want to be able to subscribe or unsubscribe on question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Unauthenticated user tries' do
    it 'subscribe or unsubscribe' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  context 'Author', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'already subscribed' do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribe from his question' do
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  context 'Authenticated user', js: true do
    given(:other_user) { create(:user) }
    given!(:subscription) { create(:subscription, question: question, user: user) }

    before do
      sign_in(other_user)
      visit question_path(question)

      click_on 'Subscribe'
    end

    scenario 'subscribe to the question' do
      expect(page).to have_link 'Unsubscribe'
      expect(page).to_not have_link 'Subscribe'
    end

    scenario 'unsubscribe to the question' do
      click_on 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
