class ChallengesController < ApplicationController

  def index

  end

  def new
    @users = User.all
  end

  def create
    @challenge = Challenge.new
  end

  def show

  end

  private

  def challenge_params
    params.require(:challege).permit(:user_id, :rival_id)
  end

end
