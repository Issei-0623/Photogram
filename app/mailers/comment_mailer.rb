class CommentMailer < ApplicationMailer
  def mention_notification(user, comment)
    @user = user
    @comment = comment

    mail(
      to: @user.email,
      subject: "メンション通知"
    )
  end
end