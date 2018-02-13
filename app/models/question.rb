class Question < ApplicationRecord
  has_many :quiz_questions
  has_many :quizzes, through: :quiz_questions


  def random_answers
    ans = []
    ans << self.correct_answer
    ans << self.wrong_answer_1
    ans << self.wrong_answer_2
    ans << self.wrong_answer_3
    ans.shuffle
  end
end
