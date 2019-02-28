# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join 'spec/models/concerns/voteable_spec'
require Rails.root.join 'spec/models/concerns/commentable_spec'

RSpec.describe Question, type: :model do
  it_behaves_like 'voteable' do
    let(:user) { create(:user) }
    let(:resource) { create(:question, user: user) }
  end
  it_behaves_like 'commentable'

  it { should have_one(:reward).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it_behaves_like 'Check many attached files' do
    let(:object) { Question }
  end
end
