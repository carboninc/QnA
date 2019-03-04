class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |user|
      NewAnswerMailer.answer(user, answer).deliver_later
    end
  end
end