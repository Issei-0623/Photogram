class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post = @post

    if @comment.save
      mentioned_name = @comment.content[/@(\w+)/, 1]
      target_user = User.find_by(account_name: mentioned_name)
      
      CommentMailer.mention_notification(target_user, @comment).deliver_later if target_user.present?

      @comments = @post.comments.includes(:user).order(created_at: :desc)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post) }
      end
    else
      redirect_to post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end