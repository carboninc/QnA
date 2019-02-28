# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join 'spec/controllers/concerns/voted_spec'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:resource) { create(:answer, question: question, user: user) }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  let(:other_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it_behaves_like 'Create object in database' do
        let(:params) { { question_id: question, answer: attributes_for(:answer) } }
        let(:object) { question.answers }
      end

      it_behaves_like 'Render create template' do
        let(:params) { { question_id: question, answer: attributes_for(:answer) } }
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'Does not create object in database' do
        let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid) } }
        let(:object) { Answer }
      end

      it_behaves_like 'Render create template' do
        let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid) } }
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it_behaves_like 'Render update template' do
        let(:params) { { id: answer, answer: attributes_for(:answer) } }
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it_behaves_like 'Render update template' do
        let(:params) { { id: answer, answer: attributes_for(:answer, :invalid) } }
      end
    end

    context 'Author tries' do
      it 'update the answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it_behaves_like 'Render update template' do
        let(:params) { { id: answer, answer: attributes_for(:answer) } }
      end
    end

    context 'Not author tries' do
      before { login(other_user) }

      it 'update the answer' do
        patch :update, params: { id: answer, answer: 'other_answer' }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'other_answer'
      end

      it_behaves_like 'Render update template' do
        let(:params) { { id: answer, answer: attributes_for(:answer) } }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, user: other_user) }

    before { login(user) }

    context 'Author tries' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it_behaves_like 'Render destroy template' do
        let(:params) { { id: answer } }
      end
    end

    context 'Not author tries' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.not_to change(Answer, :count)
      end

      it_behaves_like 'Render destroy template' do
        let(:params) { { id: other_answer } }
      end
    end
  end

  describe 'POST #mark_best_answer' do
    context 'The owner of the question is trying to mark the answer as the best' do
      before { login(user) }
      before { post :mark_best, params: { id: answer }, format: :js }

      it 'mark best answer' do
        expect { answer.reload }.to change { answer.best }.from(false).to(true)
      end

      it_behaves_like 'Render best template'
    end

    context 'Not the owner of the question is trying to mark the answer as the best' do
      before { login(other_user) }
      before { post :mark_best, params: { id: answer }, format: :js }

      it 'Do not mark the best answer' do
        expect { answer.reload }.not_to change(answer, :best)
      end

      it_behaves_like 'Render best template'
    end
  end
end
