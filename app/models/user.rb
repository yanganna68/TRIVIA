class User < ApplicationRecord
  has_many :challenges
  has_many :rivals, through: :challenges
  has_many :quizzes, through: :challenges

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, length: { minimum: 4 }

  has_secure_password

  def create_challenge(rival)
    Challenge.create(user_id: self.id, rival_id: rival.id)
  end

  def challenges
    result = []
    result << Challenge.where(user_id: self.id)
    result << Challenge.where(rival_id: self.id)
    result.flatten
  end




end
