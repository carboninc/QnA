class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi subscriber"
    @questions = Question.last_day

    mail to: user.email, subject: 'Daily digest'
  end
end
