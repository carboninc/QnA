# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:other_user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Reward to question' do
      expect(assigns(:exposed_question).reward).to be_a_new(Reward)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:exposed_question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'Author tries' do
      it 'update the question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        question.reload
        expect(question.title).to eq question.title
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not author tries' do
      let!(:initial_question) { { title: question.title, body: question.body } }

      before { login(other_user) }
      before { patch :update, params: { id: question, question: attributes_for(:question) }, format: :js }

      it 'update the question' do
        question.reload
        expect(question.title).to eq initial_question[:title]
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    let!(:other_user) { create(:user) }
    let!(:other_question) { create(:question, user: other_user) }

    before { login(user) }

    context 'Author tries' do
      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author tries' do
      it 'delete the question' do
        expect { delete :destroy, params: { id: other_question } }.not_to change(Question, :count)
      end
    end
  end
end
