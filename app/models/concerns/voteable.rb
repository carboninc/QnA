# frozen_string_literal: true

# ------------------------------------------------
module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def up(user)
    voting(user, 1)
  end

  def down(user)
    voting(user, -1)
  end

  def rating
    votes.sum(:value)
  end

  private

  def voting(user, value)
    votes.create(user: user, value: value) unless user_vote(user)
    user_vote(user).destroy if user_vote(user)&.value != value
  end

  def user_vote(user)
    votes.find_by(user_id: user.id)
  end
end
