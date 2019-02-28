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

  def create
    render json: @exposed_question = current_resource_owner.questions.create(question_params)
  end

  def update
    render json: question.update(question_params)
  end

  def destroy
    render json: question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
