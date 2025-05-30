require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    context "入力に問題がない場合" do
      it "有効であること" do
        user = build(:user)
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end

    context "emailがない場合" do
      it "無効であること" do
        user_without_email = build(:user, email: "")
        expect(user_without_email).to be_invalid
        expect(user_without_email.errors[:email]).to include("が入力されていません。")
      end
    end
    context "既に存在するemailを登録しようとした場合" do
      it "無効であること" do
        user = create(:user)
        user_with_duplicated_email = build(:user, email: user.email)
        expect(user_with_duplicated_email).to be_invalid
        expect(user_with_duplicated_email.errors[:email]).to include("は既に使用されています。")
      end
    end

    context "passwordがない場合" do
      it "無効であること" do
        user_without_password = build(:user, password: "")
        expect(user_without_password).to be_invalid
        expect(user_without_password.errors[:password]).to include("が入力されていません。")
      end
    end

    context "password_confirmationがない場合" do
      it "無効であること" do
        user_without_password_confirmation = build(:user, password_confirmation: "")
        expect(user_without_password_confirmation).to be_invalid
        expect(user_without_password_confirmation.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end

    context "既に存在するnameに更新しようとした場合" do
      let!(:existing_user) { create(:user) }
      let!(:updating_user) { create(:user) }
      it "無効であること" do
        updating_user.name = existing_user.name
        valid = updating_user.valid?(:update)
        expect(valid).to be_falsey
        expect(updating_user.errors[:name]).to include("はすでに存在します")
      end
    end

    context "一意なnameに更新する場合" do
      let!(:user) { create(:user) }
      it "有効であること" do
        user.name = "uniquename"
        valid = user.valid?(:update)
        expect(valid).to be_truthy
      end
    end

    context "既に存在するuidに更新しようとした場合" do
      let!(:existing_user) { create(:user) }
      let!(:updating_user) { create(:user) }
      it "無効であること" do
        updating_user.uid = existing_user.uid
        valid = updating_user.valid?(:update)
        expect(valid).to be_falsey
        expect(updating_user.errors[:uid]).to include("はすでに存在します")
      end
    end

    context "一意なuidに更新する場合" do
      let!(:user) { create(:user) }
      it "有効であること" do
        user.uid = "uniqueuid"
        valid = user.valid?(:update)
        expect(valid).to be_truthy
      end
    end
  end

  describe "お気に入り・ブックマーク" do
    let(:user) { create(:user) }
    let(:shortcut) { create(:shortcut) }

    it "#favoriteと#favorite?" do
      user.favorite(shortcut)
      expect(user.favorite?(shortcut)).to be true
    end

    it "#unfavorite" do
      user.favorite(shortcut)
      user.unfavorite(shortcut)
      expect(user.favorite?(shortcut)).to be false
    end

    it "#bookmarkと#bookmark?" do
      user.bookmark(shortcut)
      expect(user.bookmark?(shortcut)).to be true
    end

    it "#unbookmark" do
      user.bookmark(shortcut)
      user.unbookmark(shortcut)
      expect(user.bookmark?(shortcut)).to be false
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "12345",
        info: { email: "oauth@example.com", name: "OAuth User" }
      )
    end

    it "新しいユーザーを作成する" do
      user = User.from_omniauth(auth)
      expect(user).to be_persisted
      expect(user.email).to eq "oauth@example.com"
      expect(user.provider).to eq "google_oauth2"
    end

    it "既存のユーザーを返す" do
      existing_user = create(:user, provider: "google_oauth2", uid: "12345")
      found_user = User.from_omniauth(auth)
      expect(found_user).to eq existing_user
    end
  end
end
