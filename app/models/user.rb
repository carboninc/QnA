# frozen_string_literal: true

# ------------------------------------------------
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :authorizations, dependent: :destroy
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :comments

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author?(obj)
    id == obj.user_id
  end
end
