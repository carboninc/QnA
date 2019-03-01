# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }
  end

  let(:access_token) { create(:access_token) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET /api/v1/questions/question_id/answers' do
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }
    let(:answer) { answers.first }
    let(:answer_response) { json['answers'].first }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :get }
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Response Successful'

      it_behaves_like 'Return list of object' do
        let(:object) { json['answers'] }
        let(:count) { 3 }
      end

      it_behaves_like 'Return public field' do
        let(:attributes) { %w[id body question_id created_at updated_at best] }
        let(:json_object) { answer_response }
        let(:object) { answer }
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET /api/v1/answers/id' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:answer_response) { json['answer'] }

    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
    end

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Response Successful'

      it_behaves_like 'Return public field' do
        let(:attributes) { %w[id body question_id created_at updated_at best] }
        let(:json_object) { answer_response }
        let(:object) { answer }
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].last }

        it_behaves_like 'Return list of object' do
          let(:object) { answer_response['comments'] }
          let(:count) { 3 }
        end

        it_behaves_like 'Return public field' do
          let(:attributes) { %w[id body user_id created_at updated_at] }
          let(:json_object) { comment_response }
          let(:object) { comment }
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].last }

        it_behaves_like 'Return list of object' do
          let(:object) { answer_response['links'] }
          let(:count) { 3 }
        end

        it_behaves_like 'Return public field' do
          let(:attributes) { %w[id name url created_at updated_at] }
          let(:json_object) { link_response }
          let(:object) { link }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
      let(:headers) do
        { ACCEPT: 'application/json' }
      end
    end

    context 'authorized' do
      let(:post_answer) { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }

      it 'post answer' do
        post_answer
        expect(response).to be_successful
      end
    end
  end

  describe 'UPDATE /api/v1/answers/id' do
    let!(:answer) { create(:answer, question: question, user: user) }
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
      let(:headers) do
        { ACCEPT: 'application/json' }
      end
    end

    context 'authorized' do
      before { patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token, answer: { body: '123456' } } }

      it_behaves_like 'Response Successful'

      it 'Update answer' do
        answer.reload
        expect(answer.body).to eq '123456'
      end
    end
  end

  describe 'DESTROY /api/v1/answers/id' do
    let!(:answer) { create(:answer, question: question, user: user) }
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
      let(:headers) do
        { ACCEPT: 'application/json' }
      end
    end

    context 'authorized' do
      it 'check status after destroy answer' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }
        expect(response).to be_successful
      end

      it 'check answer after destroy' do
        expect { delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token } }.to change(Answer, :count).by(-1)
      end
    end
  end
end
