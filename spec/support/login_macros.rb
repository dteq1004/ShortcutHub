module LoginMacros
  def login_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password123"
    click_on "ログイン"
  end
end
