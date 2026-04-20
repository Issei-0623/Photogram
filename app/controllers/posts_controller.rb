class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:type] == "timeline"
      following_ids = current_user.followings.ids

      @posts = Post.where(user_id: following_ids).recent

      @popular_posts = Post.where(user_id: following_ids)
                           .created_within_24h
                           .popular
                           .limit(5)
    else
      @recent_posts = Post.recent
    end
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def create
    @post = current_user.posts.build(post_params)
    @user = current_user

    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end