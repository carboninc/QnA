# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to(:commentable).optional }

  it { should validate_presence_of :body }
end