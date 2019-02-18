# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join 'spec/models/concerns/voteable_spec'

RSpec.describe Answer, type: :model do
  it_behaves_like 'voteable' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:resource) { create(:answer, question: question, user: user) }
  end

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_one(:reward) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'best answer and get reward' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    let(:other_answer) { create(:answer, question: question, user: user) }

    context 'mark best' do
      it 'mark best == true' do
        answer.mark_best
        expect(answer).to be_best
      end

      it 'mark best == false' do
        answer.mark_best
        expect(answer).to be_best
        answer.mark_best
        expect(answer).not_to be_best
      end

      it 'only one answer may be the best' do
        answer.mark_best
        other_answer.mark_best
        expect(question.answers.where(best: true).count).to eq 1
      end
    end

    context 'get reward' do
      let!(:reward) { create(:reward, question: question) }

      it 'answer marked as awarded' do
        answer.mark_best
        expect(answer.reward).to eq reward
      end

      it 'user marked as awarded' do
        answer.mark_best
        expect(reward.user).to eq user
      end
    end
  end
end
