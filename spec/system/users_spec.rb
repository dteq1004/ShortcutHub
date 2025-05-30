require "rails_helper"

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    describe "ユーザー新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザーの新規作成が成功する" do
          visit new_user_registration_path
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "同意して登録"
          expect(page).to have_content "ユーザー登録が完了しました。認証メールをご確認ください。"
          expect(current_path).to eq root_path
        end
      end

      context "メールアドレスが未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_registration_path
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "同意して登録"
          expect(page).to have_content "正しいメールアドレスを入力してください"
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "登録済のメールアドレスを使用" do
        it "ユーザーの新規作成が失敗する" do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in "メールアドレス", with: existed_user.email
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "同意して登録"
          expect(page).to have_content "正しいメールアドレスを入力してください"
          expect(current_path).to eq new_user_registration_path
          expect(page).to have_field "メールアドレス", with: existed_user.email
        end
      end
    end

    describe "マイページ" do
      context "ログインしていない状態" do
        it "マイページへのアクセスが失敗する" do
          visit mypage_path
          expect(page).to have_content("ログインもしくはアカウント登録してください。")
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end

  describe "ログイン後" do
    before do
      login_as(user)
      expect(page).to have_content("ログインしました")
    end
    describe "ユーザー編集" do
      context "フォームの入力値が正常" do
        it "ユーザーの編集が成功する" do
          visit edit_user_path(user)
          fill_in "ユーザーネーム", with: "username"
          fill_in "ユーザーID", with: SecureRandom.base36
          click_button "更新する"
          expect(page).to have_content("ユーザー情報を更新しました")
          expect(current_path).to eq mypage_path
        end
      end

      context "ユーザーネームが未入力" do
        it "ユーザーの編集が失敗する" do
          visit edit_user_path(user)
          fill_in "ユーザーネーム", with: ""
          fill_in "ユーザーID", with: SecureRandom.base36
          click_button "更新する"
          expect(page).to have_content("更新に失敗しました")
          expect(current_path).to eq edit_user_path(user)
        end
      end

      context "登録済のユーザーネームを使用" do
        it "ユーザーの編集が失敗する" do
          visit edit_user_path(user)
          other_user = create(:user)
          fill_in "ユーザーネーム", with: other_user.name
          fill_in "ユーザーID", with: SecureRandom.base36
          click_button "更新する"
          expect(page).to have_content("更新に失敗しました")
          expect(current_path).to eq edit_user_path(user)
        end
      end

      context "他ユーザーの編集ページにアクセス" do
        it "編集ページへのアクセスが失敗する" do
          other_user = create(:user)
          visit edit_user_path(other_user)
          expect(current_path).to eq user_path(other_user)
        end
      end
    end
  end
end
