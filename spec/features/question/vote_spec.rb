# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the question', "
  To vote for an interesting question
  As authenticated user
  I would like to be able to vote
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Unauthenticated user tries' do
    scenario 'vote an question' do
      visit question_path(question)

      within(".vote-question-block-id-#{question.id}") do
        find('.vote-up').click
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'Not the author votes for the question', js: true do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'First vote up' do
      within(".vote-question-block-id-#{question.id}") do
        find('.vote-up').click
        expect(page).to have_content '1'
      end
    end

    scenario 'Re-vote up' do
      within(".vote-question-block-id-#{question.id}") do
        receive(find('.vote-up').click).twice

        expect(page).to have_content '1'
      end
    end

    scenario 'Cancel vote up' do
      within(".vote-question-block-id-#{question.id}") do
        find('.vote-up').click
        find('.vote-down').click

        expect(page).to have_content '0'
      end
    end

    scenario 'First vote down' do
      within(".vote-question-block-id-#{question.id}") do
        find('.vote-down').click

        expect(page).to have_content '-1'
      end
    end

    scenario 'Re-vote down' do
      within(".vote-question-block-id-#{question.id}") do
        receive(find('.vote-down').click).twice

        expect(page).to have_content '-1'
      end
    end

    scenario 'Cancel vote down' do
      within(".vote-question-block-id-#{question.id}") do
        find('.vote-down').click
        find('.vote-up').click

        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author cannot vote for the question', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Vote up' do
      within(".vote-question-block-id-#{question.id}") do
        find('.vote-up').click
      end

      expect(page).to have_content 'You can not vote for your question'
    end

    scenario 'Vote down' do
      within(".vote-question-block-id-#{question.id}") do
        find('.vote-down').click
      end

      expect(page).to have_content 'You can not vote for your question'
    end
  end
end