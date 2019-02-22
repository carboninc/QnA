# frozen_string_literal: true

# ------------------------------------------------
class CommentsController < ActionController::Base
  before_action :authenticate_user!
  before_action :find_resource, only: :create

  expose :comment

  def create
    @exposed_comment = @resource.comments.create(comment_params.merge(user_id: current_user.id))
  end

  private

  def find_resource
    return @resource = Answer.find(params[:answer_id]) if params[:answer_id]

    @resource = Question.find(params[:question_id]) if params[:question_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end