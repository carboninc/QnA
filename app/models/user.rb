# frozen_string_literal: true

# ------------------------------------------------
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :authorizations, dependent: :destroy
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :comments
  has_many :subscriptions

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author?(obj)
    id == obj.user_id
  end

  def subscribed?(question)
    subscriptions.exists?(question: question)
  end
end
