
class QuizzesController < ApplicationController
  before_action :logged_in?
  before_action :can_access_own_quiz, :except => [:new, :create]
  before_action :can_not_go_back, :except => [:new, :create, :result]


  def new
    @challenge = Challenge.find(find_challenge_params.to_i)
    @categories = AVAILABLE_CATEGORIES
    @quiz = Quiz.new
  end

  def create
    @category = AVAILABLE_CATEGORIES.select {|k, v| v == create_quiz_params[:id].to_i}
    @challenge = Challenge.find(create_quiz_params[:challenge_id].to_i)
    @quiz = Quiz.create(category_name: @category.keys[0].to_s, category_id: @category.values[0], challenge_id: @challenge.id)
    quiz_questions_building_helper(@quiz)
    redirect_to "/users/#{session[:user_id]}/quizzes/#{@quiz.id}"
  end


  def show
    @quiz = Quiz.find(find_quiz_params.to_i)
  end

  def compare

    @quiz = Quiz.find(compare_question_params[:id].to_i)
    @questions = @quiz.questions
    @correct_answers = @questions.map { |q| q.correct_answer }
    @user_answers = []
    @user_answers << compare_question_params[:questions]["1"]
    @user_answers << compare_question_params[:questions]["2"]
    @user_answers << compare_question_params[:questions]["3"]
    @user_answers << compare_question_params[:questions]["4"]
    @user_answers << compare_question_params[:questions]["5"]

    count = 0
    @user_answers.each do |a|
      if @correct_answers.include?(a)
        count += 1
      end
    end
    if session[:user_id] == @quiz.challenge.user_id
      @quiz.update(user_score: count)
    else
      @quiz.update(rival_score: count)
    end

    current_user.score += count
    current_user.save

    redirect_to "/users/#{session[:user_id]}/quizzes/#{@quiz.id}/result"
  end


  def result

    @quiz = Quiz.find(result_params[:id].to_i)
    @questions = @quiz.questions
    @challenge = Challenge.find(@quiz.challenge_id)
  if session[:user_id] == @quiz.challenge.user_id
    @rival = User.find(@challenge.rival_id)
    @user = User.find(session[:user_id])
  else
    @rival = User.find(session[:user_id])
    @user = User.find(@challenge.user_id)
  end


  end

  def quiz_questions_building_helper(quiz)
    url = get_category_route(create_quiz_params[:id].to_i)
    @questions = parse_category_route(url)
    question_creation_helper(quiz, @questions, 0)
    question_creation_helper(quiz, @questions, 1)
    question_creation_helper(quiz, @questions, 2)
    question_creation_helper(quiz, @questions, 3)
    question_creation_helper(quiz, @questions, 4)
  end

  def question_creation_helper(quiz, questions, question_num)
    question = Question.find_or_create_by(category_id: params[:id].to_i, question_text: questions["results"][question_num]["question"])
    question.update(correct_answer: questions["results"][question_num]["correct_answer"])
    question.update(wrong_answer_1: questions["results"][question_num]["incorrect_answers"][0])
    question.update(wrong_answer_2: questions["results"][question_num]["incorrect_answers"][1])
    question.update(wrong_answer_3: questions["results"][question_num]["incorrect_answers"][2])
    quiz.questions << question
  end

  def can_access_own_quiz
    @quiz = Quiz.find(find_quiz_params.to_i)
    if @quiz.challenge.user_id != current_user.id && @quiz.challenge.rival_id != current_user.id
      return head(:forbidden)
    end
  end

  def can_not_go_back
    @quiz = Quiz.find(find_quiz_params.to_i)
    if session[:user_id] == @quiz.challenge.user_id && @quiz.user_score
      return head(:forbidden)
    elsif session[:user_id] == @quiz.challenge.rival_id && @quiz.rival_score
      return head(:forbidden)
    end
  end

  private
  def create_quiz_params
    params.permit(:id, :challenge_id)
  end

  def find_challenge_params
    params.require(:challenge_id)
  end

  def find_quiz_params
    params.require(:id)
  end

  def compare_question_params
    params.permit!
  end

  def result_params
    params.permit(:id)
  end

end
