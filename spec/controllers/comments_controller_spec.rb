# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { create(:comment, commentable: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment for question in the database' do
        expect { post :create, params: {question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(question.comments, :count).by(1)
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(user.comments, :count).by(1)
      end

      it_behaves_like 'Render create template' do
        let(:params) { { question_id: question, comment: attributes_for(:comment) } }
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js }.to_not change(question.comments, :count)
      end

      it_behaves_like 'Render create template' do
        let(:params) { { question_id: question, comment: attributes_for(:comment, :invalid) } }
      end
    end
  end
end