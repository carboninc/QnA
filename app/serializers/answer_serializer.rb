class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :best, :files
  belongs_to :user
  has_many :comments
  has_many :links

  def files
    object.files.map(&:service_url)
  end
end