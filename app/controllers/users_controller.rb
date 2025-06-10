class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[ show show_lazy ]
  before_action :ensure_user, only: %i[ edit update destroy ]

  def show
    @user = User.find_by(uid: params[:uid])
    unless @user != current_user
      redirect_to mypage_path
    end
  end

  def show_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @user = User.find_by(uid: params[:user_uid])
    @shortcuts = @user.shortcuts.where(status: :published).order(updated_at: :desc)
  end

  def edit
  end

  def update
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.update(user_params)
      redirect_to mypage_path, notice: "ユーザー情報を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path
  end

  def mypage
  end

  def mypage_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @shortcuts = current_user.shortcuts.all.order(updated_at: :desc)
  end

  def bookmarks
  end

  def bookmarks_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @bookmark_shortcuts = current_user.bookmark_shortcuts.includes(:user).where(status: :published).order(updated_at: :desc)
  end

  def analytics
  end

  def analytics_lazy
    unless request.headers["Turbo-Frame"]
      redirect_to root_path
    end
    @shortcuts_view_count = current_user.shortcuts.where(status: :published).order(view_count: :desc).limit(5)
    @shortcuts_bookmark = Shortcut.where(status: :published).select("shortcuts.*, COUNT(bookmarks.id) AS bookmarks_count").left_joins(:bookmarks).where(user_id: current_user.id).group("shortcuts.id").order("bookmarks_count DESC").limit(5)
    @shortcuts_favorite = Shortcut.where(status: :published).select("shortcuts.*, COUNT(favorites.id) AS favorites_count").left_joins(:favorites).where(user_id: current_user.id).group("shortcuts.id").order("favorites_count DESC").limit(5)
  end

  def email
  end

  def email_change
    new_email = params[:user][:unconfirmed_email]
    if new_email.blank?
      redirect_to user_email_path, alert: "新しいメールアドレスを入力してください"
      return
    end

    if new_email == current_user.email
      redirect_to user_email_path, alert: "別のメールアドレスを入力してください"
      return
    end

    token = SecureRandom.urlsafe_base64
    current_user.update!(
      unconfirmed_email: new_email,
      confirmation_token: token,
      confirmation_sent_at: Time.current
    )

    UserMailer.email_change_confirmation(current_user, token).deliver_now
    redirect_to mypage_path, notice: "確認メールを送信しました"
  end

  def confirm
    user = User.find_by(confirmation_token: params[:token])
    if user && user.confirmation_sent_at > 1.hour.ago
      user.skip_reconfirmation!
      if user.update(email: user.unconfirmed_email, unconfirmed_email: nil, confirmation_token: nil)
        redirect_to mypage_path, notice: "メールアドレスの変更が完了しました"
      else
        Rails.logger.error "Email change failed: #{user.errors.full_messages.join(', ')}"
        redirect_to mypage_path, alert: "メールアドレスの変更に失敗しました"
      end
    else
      redirect_to mypage_path, alert: "トークンが無効または期限切れです"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :uid, :avatar)
  end

  def ensure_user
    @user = User.find_by(uid: params[:uid])
    if @user != current_user
      redirect_to user_path(@user)
    end
  end
end
