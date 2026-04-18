class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update following followers]
  before_action :ensure_correct_user, only: [:update]

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def update
    if params[:remove_avatar] == "1"
      @user.avatar.purge if @user.avatar.attached?
    end

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      @posts = @user.posts.order(created_at: :desc)
      render :show, status: :unprocessable_entity
    end
  end

  def following
    @users = @user.followings
    @page_title = "Following"
  end

  def followers
    @users = @user.followers
    @page_title = "Followers"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    redirect_to user_path(@user), alert: "権限がありません" unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:account_name, :avatar)
  end
end