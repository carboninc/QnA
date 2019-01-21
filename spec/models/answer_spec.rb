require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe 'best answer' do
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
  end
end
