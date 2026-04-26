class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

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
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    redirect_to post_path(@post), alert: "権限がありません" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end