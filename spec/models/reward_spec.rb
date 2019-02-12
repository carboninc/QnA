# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question).dependent(:destroy) }
  it { should belong_to :answer }
  it { should belong_to :user }

  it { should validate_presence_of :name }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
