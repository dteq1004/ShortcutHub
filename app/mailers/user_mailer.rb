class UserMailer < ApplicationMailer
  def email_change_confirmation(user, token)
    @user = user
    @url = user_confirm_url(token: token)
    mail to: user.unconfirmed_email, subject: "メールアドレス変更の確認"
  end
end
