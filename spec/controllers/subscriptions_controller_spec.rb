# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:create_params) { { question_id: question, user: user } }

    context 'Unauthenticated user' do
      it 'does not save the subscription' do
        expect { post :create, params: create_params, format: :js }.to_not change(Subscription, :count)
      end
    end

    context 'Authenticated user' do
      before { sign_in(user) }

      it_behaves_like 'Create object in database' do
        let(:params) { create_params }
        let(:object) { user.subscriptions }
      end

      it_behaves_like 'Create object in database' do
        let(:params) { create_params }
        let(:object) { question.subscriptions }
      end

      it_behaves_like 'Render create template' do
        let(:params) { create_params }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, question: question, user: user }
    let(:other_user) { create(:user) }

    context 'Author tries' do
      before { sign_in(user) }

      it 'deletes his subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it_behaves_like 'Render destroy template' do
        let(:params) { { id: subscription } }
      end
    end

    context 'Not author tries' do
      before { sign_in(other_user) }

      it 'delete not his subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
