class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: :destroy

  expose :question, -> { Question.find(params[:question_id]) }

  authorize_resource

  def create
    @subscription = question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription.destroy
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end