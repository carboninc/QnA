# frozen_string_literal: true

# ------------------------------------------------
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, -> { Question.with_attached_files.find(params[:id]) }
  expose :answer, -> { Answer.new }

  def create
    @exposed_question = current_user.questions.new(question_params)
    if question.save
      redirect_to question_path(question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author?(question)
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question has been deleted.'
    else
      redirect_to questions_path, notice: 'Oops! You are not the author of the question.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
