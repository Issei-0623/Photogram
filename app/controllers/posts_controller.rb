class PostsController < ApplicationController
  POSTS_PER_PAGE = 20
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:type] == "timeline"
      following_ids = current_user.followings.ids

      @posts = paginated_posts(Post.where(user_id: following_ids))

      @popular_posts = Post.where(user_id: following_ids)
                           .created_within_24h
                           .popular
                           .includes(:user, :likes, images_attachments: :blob, user: { avatar_attachment: :blob })
                           .limit(5)
    else
      @recent_posts = paginated_posts(Post.all)
    end

    rendered_posts = params[:type] == "timeline" ? @posts + @popular_posts.to_a : @recent_posts
    @liked_post_ids = current_user.likes.where(post_id: rendered_posts.map(&:id)).pluck(:post_id).to_set
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

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "投稿を削除しました", status: :see_other }
      format.turbo_stream { redirect_to posts_path(format: :html), notice: "投稿を削除しました", status: :see_other }
    end
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

  def paginated_posts(scope)
    posts = scope
            .includes(:user, :likes, images_attachments: :blob, user: { avatar_attachment: :blob })
            .order(created_at: :desc, id: :desc)

    if params[:before].present? && params[:before_id].present?
      before_time = Time.zone.parse(params[:before])
      before_id = params[:before_id].to_i
      posts = posts.where("posts.created_at < ? OR (posts.created_at = ? AND posts.id < ?)", before_time, before_time, before_id)
    end

    page = posts.limit(POSTS_PER_PAGE + 1).to_a
    @has_next_page = page.size > POSTS_PER_PAGE
    page = page.first(POSTS_PER_PAGE)
    @next_cursor = page.last
    page
  end
end
