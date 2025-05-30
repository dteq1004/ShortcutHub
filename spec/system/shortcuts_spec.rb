require "rails_helper"

RSpec.describe "Shortcuts", type: :system do
  let(:user) { create(:user) }
  let(:shortcut) { create(:shortcut) }

  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "ショートカットの新規登録ページにアクセス" do
        it "新規登録ページへのアクセスが失敗する" do
          visit new_shortcut_path
          expect(page).to have_content("ログインもしくはアカウント登録してください。")
          expect(current_path).to eq new_user_session_path
        end
      end

      context "ショートカットの編集ページにアクセス" do
        it "編集ページへのアクセスが失敗する" do
          visit edit_shortcut_path(shortcut)
          expect(page).to have_content("ログインもしくはアカウント登録してください。")
          expect(current_path).to eq new_user_session_path
        end
      end

      context "ショートカットの詳細ページにアクセス" do
        let!(:shortcut) { create(:shortcut, :published_with_description)}
        it "ショートカットの詳細情報が表示される" do
          visit shortcut_path(shortcut)
          expect(page).to have_content shortcut.title
          expect(page).to have_content shortcut.description
          expect(current_path).to eq shortcut_path(shortcut)
        end
      end

      context "ショートカットの一覧ページにアクセス" do
        it "すべてのユーザーのショートカット情報が表示される" do
          shortcut_list = create_list(:shortcut, 3, :published_with_description)
          visit shortcuts_path
          expect(page).to have_content shortcut_list[0].title
          expect(page).to have_content shortcut_list[1].title
          expect(page).to have_content shortcut_list[2].title
          expect(current_path).to eq shortcuts_path
        end
      end
    end
  end

  describe "ログイン後" do
    before do
      login_as(user)
      expect(page).to have_content("ログインしました")
    end

    describe "ショートカット新規登録" do
      context "フォームの入力値が正常" do
        it "ショートカットの新規作成が成功する" do
          visit new_shortcut_path
          fill_in "タイトル", with: "test_title"
          click_button "詳細の入力へ"
          expect(page).to have_content "投稿を作成しました！詳細を入力してください！"
          created_shortcut = Shortcut.last
          expect(current_path).to eq edit_shortcut_path(created_shortcut)
        end
      end

      context "タイトルが未入力" do
        it "ショートカットの新規作成が失敗する" do
          visit new_shortcut_path
          fill_in "タイトル", with: ""
          expect(page).to have_button "詳細の入力へ", disabled: true
        end
      end
    end

    describe "ショートカット編集" do
      let!(:shortcut) { create(:shortcut, user: user) }
      let(:other_shortcut) { create(:shortcut, user: user) }
      before { visit edit_shortcut_path(shortcut) }

      context "フォームの入力値が正常" do
        it "ショートカットの編集が成功する" do
          fill_in "説明", with: "updated_description"
          click_button "下書きを保存"
          expect(page).to have_content "下書きを保存しました"
          expect(current_path).to eq mypage_path
        end
      end

      context "他ユーザーのショートカット編集ページにアクセス" do
        let!(:other_user) { create(:user, email: "other_user@example.com") }
        let!(:other_shortcut) { create(:shortcut, :published_with_description, user: other_user) }
        it "編集ページへのアクセスが失敗する" do
          visit edit_shortcut_path(other_shortcut)
          expect(current_path).to eq shortcut_path(other_shortcut)
        end
      end
    end

    describe "ショートカット削除" do
      it "ショートカットの削除が成功する" do
        shortcut = create(:shortcut, :published_with_description, user: user)
        visit mypage_path
        within "#shortcut-#{shortcut.id}" do
          find("div[role='button']").click
          accept_confirm do
            click_link "削除"
          end
        end
        expect(page).not_to have_selector "shortcut-#{shortcut.id}"
        expect(page).to have_content "削除しました"
        expect(current_path).to eq mypage_path
      end
    end
  end
end
