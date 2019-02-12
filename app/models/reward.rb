# frozen_string_literal: true

# ------------------------------------------------
class Reward < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :answer
  belongs_to :user

  has_one_attached :image

  validates :name, :image, presence: true
end