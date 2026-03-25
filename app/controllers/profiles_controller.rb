class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user

    if params[:remove_avatar] == "1"
      @user.avatar.purge if @user.avatar.attached?
    end

    if @user.update(profile_params)
      redirect_to profile_path, notice: "プロフィールを更新しました"
    else
      flash.now[:alert] = "プロフィールを更新できませんでした"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:account_name, :avatar)
  end
end