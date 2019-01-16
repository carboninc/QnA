# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:other_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
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

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author tries' do
      it 'update the answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not author tries' do
      before { login(other_user) }

      it 'update the answer' do
        patch :update, params: { id: answer, answer: 'other_answer' }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'other_answer'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
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
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not author tries' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: other_answer } }.not_to change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: other_answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
