# frozen_string_literal: true

# ------------------------------------------------
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  include Voted

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answer, -> { Answer.new }

  def new
    question.links.new
    question.reward = Reward.new
  end

  def show
    answer.links.new
  end

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
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name image]
    )
  end
end
