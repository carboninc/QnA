# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, user: other_user) }
  let(:other_answer) { create(:answer, question: other_question, user: other_user) }

  it 'User is author of question' do
    expect(user).to be_author(question)
  end

  it 'User is not author of question' do
    expect(user).not_to be_author(other_question)
  end

  it 'User is author of answer' do
    expect(user).to be_author(answer)
  end

  it 'User is not author of answer' do
    expect(user).not_to be_author(other_answer)
  end
end
