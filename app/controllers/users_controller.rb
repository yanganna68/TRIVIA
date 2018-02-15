class UsersController < ApplicationController
before_action :logged_in?, :except => [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show

    @challenges = current_user.challenges
    @quizzes = []
    @challenges.each do |c|
      @quizzes << c.quizzes
    end
    @quizzes.flatten!
  end

  def edit
    @user = current_user
  end

  def update

    @user = current_user
    @user.update(user_params)
    if @user.valid?
      redirect_to user_path(@user)
    else
      render :edit
    end

  end


  def stats
    @users = User.all
    @user = current_user
    @users_scores = Hash.new
    @users.each do |user|
      @users_scores[user.username] = user.score
    end
    @users_scores = @users_scores.sort_by{|k,v| v}.reverse!
    if @users_scores.length <= 10
      @users_scores
    else
      @users_scores = Hash[@users_scores.to_a[0,9]]
    end
  end



  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
