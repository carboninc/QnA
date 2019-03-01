# frozen_string_literal: true

# ------------------------------------------------
class Question < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  scope :last_day, -> { where('created_at >= ?', 1.day.ago) }

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
