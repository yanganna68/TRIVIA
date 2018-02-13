class Challenge < ApplicationRecord
  has_many :quizzes
  belongs_to :user
  belongs_to :rival, :class_name => 'User'
end
