# frozen_string_literal: true

# ------------------------------------------------
class AnswersController < ApplicationController
  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    answer = question.answers.new(answer_params)
    if answer.save
      redirect_to question_answer_path(question, answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
