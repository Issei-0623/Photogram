class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.likes.create!(post: @post)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post_path(@post) }
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.likes.find_by!(post: @post).destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post_path(@post) }
    end
  end
end