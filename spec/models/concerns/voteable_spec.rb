# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'voteable' do
  describe 'User can voting' do
    context 'up' do
      it 'user votes for the first time' do
        resource.up(user)
        expect(resource.votes.count).to eq 1
      end
      it 'user votes again' do
        receive(resource.up(user)).twice
        expect(resource.votes.count).to eq 1
      end
    end

    context 'down' do
      it 'user votes for the first time' do
        resource.down(user)
        expect(resource.votes.count).to eq 1
      end
      it 'user votes again' do
        receive(resource.down(user)).twice
        expect(resource.votes.count).to eq 1
      end
    end

    context 'cancel vote' do
      it 'rollback vote if voted up' do
        resource.up(user)
        resource.down(user)
        expect(resource.votes.count).to eq 0
      end

      it 'rollback vote if voted down' do
        resource.down(user)
        resource.up(user)
        expect(resource.votes.count).to eq 0
      end

      it 'rollback vote if voted down test' do
        resource.down(user)
        resource.up(user)
        expect(resource.votes.count).to eq 0
      end
    end
  end

  describe 'Rating' do
    before do
      create(:vote_up, voteable: resource, user: user)
      create(:vote_down, voteable: resource, user: user)
    end

    it 'Sum votes' do
      expect(resource.rating).to eq 0
    end
  end
end