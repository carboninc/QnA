require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create :answer, question: question, user: user }
  let(:subscriptions) { create_list(:subscription, 2, question: question, user: user) }

  it 'sends notification email to subscribers' do
    question.subscribers.each { |subscriber| expect(NewAnswerMailer).to receive(:answer).with(subscriber, answer).and_call_original }

    AnswerNotificationJob.perform_now(answer)
  end
end