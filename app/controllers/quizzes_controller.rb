require 'pry-rails'
class QuizzesController < ApplicationController


  def index

    # @quiz = Quiz.create(challenge_id: )
    @categories = AVAILABLE_CATEGORIES
  end

  def show
    url = get_category_route(params[:id])
    @questions = parse_category_route(url)

    @question1 = question_creation_helper(0)
    @question2 = question_creation_helper(1)
    @question3 = question_creation_helper(2)
    @question4 = question_creation_helper(3)
    @question5 = question_creation_helper(4)

  end

  def question_creation_helper(question_num)
    question = Question.find_or_create_by(category_id:params[:id], question_text: @questions["results"][question_num]["question"])
    question.update(correct_answer: @questions["results"][question_num]["correct_answer"])
    question.update(wrong_answer_1: @questions["results"][question_num]["incorrect_answers"][0])
    question.update(wrong_answer_2: @questions["results"][question_num]["incorrect_answers"][1])
    question.update(wrong_answer_3: @questions["results"][question_num]["incorrect_answers"][2])
    question
  end

end
