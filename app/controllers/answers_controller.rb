# frozen_string_literal: true

# ------------------------------------------------
class AnswersController < ApplicationController
  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @exposed_answer = question.answers.new(answer_params)

    if @exposed_answer.save
      redirect_to @exposed_answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
