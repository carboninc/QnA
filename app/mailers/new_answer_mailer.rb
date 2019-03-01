class NewAnswerMailer < ApplicationMailer
  def answer(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email, subject: 'New answer'
  end
end
