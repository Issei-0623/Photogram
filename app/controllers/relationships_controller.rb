class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to user_path(user)
  end

  def destroy
    relationship = current_user.active_relationships.find(params[:id])
    user = relationship.followed
    current_user.unfollow(user)
    redirect_to user_path(user)
  end
end