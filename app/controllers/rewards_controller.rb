# frozen_string_literal: true

# ------------------------------------------------
class RewardsController < ApplicationController
  before_action :authenticate_user!

  expose :rewards, -> { Reward.all }
  expose :user_rewards, -> { current_user.rewards }
end
