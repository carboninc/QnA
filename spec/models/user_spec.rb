# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, user: other_user) }

  it 'User is author of question' do
    expect(user).to be_author(question)
  end

  it 'User is not author of question' do
    expect(user).not_to be_author(other_question)
  end
end
