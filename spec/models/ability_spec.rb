# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:answer) { create :answer, question: question, user: user }
    let(:comment) { create :comment, commentable: question, user: user }
    let(:link) { create :link, linkable: question }
    let(:subscription) { create(:subscription, question: question, user: user) }

    let(:other_user) { create :user }
    let(:other_question) { create :question, user: other_user }
    let(:other_answer) { create :answer, user: other_user, question: question }
    let(:other_comment) { create :comment, commentable: question, user: other_user }
    let(:other_subscription) { create(:subscription, question: question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    it { should be_able_to :destroy, subscription }
    it { should_not be_able_to :destroy, other_subscription }

    it { should be_able_to :mark_best, answer }

    it { should be_able_to :destroy, link }

    it { should be_able_to :destroy, ActiveStorage::Attachment }

    it { should be_able_to :vote_up, other_answer }
    it { should be_able_to :vote_down, other_answer }

    it { should be_able_to :me, User }
  end
end
