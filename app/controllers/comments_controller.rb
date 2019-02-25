# frozen_string_literal: true

# ------------------------------------------------
class CommentsController < ActionController::Base
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  after_action :publish_comment, only: :create

  expose :comment

  authorize_resource

  def create
    @exposed_comment = @resource.comments.create(comment_params.merge(user_id: current_user.id))
  end

  private

  def publish_comment
    return if comment.errors.any?

    resource = @resource.is_a?(Question) ? @resource.id : @resource.question.id
    ActionCable.server.broadcast(
      "comments_question_#{resource}",
      comment: comment
    )
  end

  def find_resource
    return @resource = Answer.find(params[:answer_id]) if params[:answer_id]

    @resource = Question.find(params[:question_id]) if params[:question_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end