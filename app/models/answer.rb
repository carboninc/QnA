class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order best: :desc }

  def mark_best
    other_best_answer = question.answers.where(best: true).first
    transaction do
      other_best_answer&.update!(best: false)
      update!(best: !best)
    end
  end
end
