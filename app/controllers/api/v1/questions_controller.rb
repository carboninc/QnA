# frozen_string_literal: true

# ------------------------------------------------
class Api::V1::QuestionsController < Api::V1::BaseController
  expose :questions, -> { Question.all }
  expose :question, -> { Question.find(params[:id]) }

  authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end
end
