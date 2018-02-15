class ChallengesController < ApplicationController
  before_action :logged_in?

  def index

  end

  def new
    @challenge = Challenge.new
    @users = []
    User.all.each do |user|
      next if user.id == session[:user_id]
      @users << user
    end
  end

  def create
    if Challenge.find_by(user_id: session[:user_id], rival_id: challenge_params[:user_id])
      @challenge = Challenge.find_by(user_id: session[:user_id], rival_id: challenge_params[:user_id])
    elsif Challenge.find_by(user_id: challenge_params[:user_id], rival_id: session[:user_id])
      @challenge = Challenge.find_by(user_id: challenge_params[:user_id], rival_id: session[:user_id])
    else
      @challenge = Challenge.create(user_id: session[:user_id], rival_id: challenge_params[:user_id])
    end
    redirect_to "/users/#{session[:user_id]}/challenges/#{@challenge.id}"
  end

  def show
    @challenge = Challenge.find(find_challenge_params[:id])
    @quizzes = Quiz.where(challenge_id: @challenge.id)
    # if @challenge.rival_id == session[:user_id] #always have current user as @challenge.user_id
    #   @challenge.update(rival_id: @challenge.user_id) && @challenge.update(user_id: session[:user_id])
    # end
    @user = User.find_by(id: @challenge.user_id)
    @rival = User.find_by(id: @challenge.rival_id)

  end

  private

  def challenge_params
    params.require("/users/#{session[:user_id]}/challenges").permit(:user_id)
  end

  def find_challenge_params
    params.permit(:id)
  end
end
