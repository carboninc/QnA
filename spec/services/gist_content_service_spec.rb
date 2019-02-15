# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GitContentService' do
  let(:gist_link) { GistContentService.new('42673bd84ded0cfc7093dee0697bd7c4') }
  let(:link) { GistContentService.new('google.com') }

  it 'Gist content received' do
    expect(gist_link.content).to eq 'Test'
  end

  it "Gist content isn't received" do
    expect(link.content).to eq nil
  end
end