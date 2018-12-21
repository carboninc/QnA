# frozen_string_literal: true

# ------------------------------------------------
class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @exposed_answer = question.answers.new(answer_params.merge(user_id: current_user.id))

    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question, notice: 'Your answer has been deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
