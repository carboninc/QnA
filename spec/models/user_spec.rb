# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'User' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, user: other_user) }

    it 'is author of question' do
      expect(user).to be_author(question)
    end

    it 'is not author of question' do
      expect(user).not_to be_author(other_question)
    end
  end

  describe '#subscribed?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, question: question, user: user) }

    let!(:other_user) { create(:user) }

    it 'User subscribed to question' do
      expect(user).to be_subscribed(subscription.question)
    end

    it 'User not subscribed to question' do
      expect(other_user).to_not be_subscribed(subscription.question)
    end
  end
end
