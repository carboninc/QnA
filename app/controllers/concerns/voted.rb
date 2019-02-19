# frozen_string_literal: true

# ------------------------------------------------
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %i[vote_up vote_down]
  end

  def vote_up
    vote(:up)
  end

  def vote_down
    vote(:down)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end

  def vote(type)
    if current_user.author?(@voteable)
      render json: { errors: "You can not vote for your #{model_klass.to_s.downcase}" }, status: 403
    else
      @voteable.send(type, current_user)
      render json: { rating: @voteable.rating, id: @voteable.id }
    end
  end
end