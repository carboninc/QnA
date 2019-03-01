# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }
  end

  let(:access_token) { create(:access_token) }

  let(:user) { create(:user) }

  describe 'GET /api/v1/questions' do
    let!(:questions) { create_list(:question, 2, user: user) }
    let(:question) { questions.first }
    let(:question_response) { json['questions'].first }

    let!(:answers) { create_list(:answer, 3, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Response Successful'

      it_behaves_like 'Return list of object' do
        let(:object) { json['questions'] }
        let(:count) { 2 }
      end

      it_behaves_like 'Return public field' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:json_object) { question_response }
        let(:object) { question }
      end

      it_behaves_like 'Check short title' do
        let(:json_object) { question_response }
        let(:object) { question }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Return list of object' do
          let(:object) { question_response['answers'] }
          let(:count) { 3 }
        end

        it_behaves_like 'Return public field' do
          let(:attributes) { %w[id body created_at updated_at best] }
          let(:json_object) { answer_response }
          let(:object) { answer }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/id' do
    let!(:question) { create(:question, user: user) }
    let(:question_response) { json['question'] }

    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let!(:links) { create_list(:link, 3, linkable: question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Response Successful'

      it_behaves_like 'Return public field' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:json_object) { question_response }
        let(:object) { question }
      end

      it_behaves_like 'Check short title' do
        let(:json_object) { question_response }
        let(:object) { question }
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].last }

        it_behaves_like 'Return list of object' do
          let(:object) { question_response['comments'] }
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
        let(:link_response) { question_response['links'].last }

        it_behaves_like 'Return list of object' do
          let(:object) { question_response['links'] }
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

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :post }
      let(:headers) do
        { ACCEPT: 'application/json' }
      end
    end

    context 'authorized' do
      let(:post_question) { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }

      it 'post question' do
        post_question
        expect(response).to be_successful
      end
    end
  end

  describe 'UPDATE /api/v1/questions/id' do
    let!(:question) { create(:question, user: user) }
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
      let(:headers) do
        { ACCEPT: 'application/json' }
      end
    end

    context 'authorized' do
      before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, question: { title: '123456' } } }

      it_behaves_like 'Response Successful'

      it 'Update question' do
        question.reload
        expect(question.title).to eq '123456'
      end
    end
  end

  describe 'DESTROY /api/v1/questions/id' do
    let!(:question) { create(:question, user: user) }
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
      let(:headers) do
        { ACCEPT: 'application/json' }
      end
    end

    context 'authorized' do
      it 'check status after destroy question' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }
        expect(response).to be_successful
      end

      it 'check question after destroy' do
        expect { delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token } }.to change(Question, :count).by(-1)
      end
    end
  end
end
