# frozen_string_literal: true

# ------------------------------------------------
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :comments

  def author?(obj)
    id == obj.user_id
  end
end
