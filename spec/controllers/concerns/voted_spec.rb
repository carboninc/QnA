# frozen_string_literal: true

require 'rails_helper'

shared_examples 'voted' do
  describe 'POST #vote_up' do
    context 'Not author can vote up' do
      before { login(other_user) }

      it 'Voting up' do
        expect { post :vote_up, params: { id: resource }, format: :json }.to change(Vote, :count).by 1
      end
    end

    context 'Author can not vote up' do
      before { login(user) }

      it 'Voting up error' do
        post :vote_down, params: { id: resource }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'POST #vote_down' do
    context 'Not author can vote down' do
      before { login(other_user) }

      it 'Voting down' do
        expect { post :vote_up, params: { id: resource }, format: :json }.to change(Vote, :count).by 1
      end
    end

    context 'Author can not vote down' do
      before { login(user) }

      it 'Voting down error' do
        patch :vote_down, params: { id: resource }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end

end