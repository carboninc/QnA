# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'User can get gist content' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, linkable: question) }
    let(:gist_link) { create(:gist_link, linkable: question) }

    context 'Link is gist?' do
      it 'Link is gist' do
        expect(gist_link).to be_gist
      end

      it "Link isn't link" do
        expect(link).not_to be_gist
      end
    end

    context 'Get gist content' do
      it 'Gist content received' do
        expect(gist_link.gist_content).to eq 'Test'
      end

      it "Gist content isn't received" do
        expect(link.gist_content).to eq nil
      end
    end
  end
end
