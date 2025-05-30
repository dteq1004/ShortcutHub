require "rails_helper"

RSpec.describe Shortcut, type: :model do
  describe "バリデーション" do
    context "title が存在する場合" do
      let!(:shortcut) { build(:shortcut, title: "サンプルショートカット") }
      it "有効であること" do
        expect(shortcut).to be_valid
      end
    end

    context "title が存在しない場合" do
      let!(:shortcut) { build(:shortcut, title: nil) }
      it "無効であること" do
        expect(shortcut).not_to be_valid
        expect(shortcut.errors[:title]).to include("を入力してください")
      end
    end

    context "download_url が存在する場合" do
      let!(:shortcut) { build(:shortcut, download_url: "https://example.com/shortcut") }
      it "有効であること" do
        expect(shortcut).to be_valid
      end
    end
  end

  describe "デフォルト値" do
    context "新規作成時" do
      let!(:shortcut) { build(:shortcut) }

      it "status は draft (0) であること" do
        expect(shortcut.status).to eq("draft")
      end

      it "description は空文字であること" do
        expect(shortcut.description).to eq("")
      end

      it "download_url は空文字であること" do
        expect(shortcut.download_url).to eq("")
      end

      it "credits は nil または 0 であること" do
        expect(shortcut.view_count).to be_nil.or eq(0)
      end
    end
  end

  describe "アソシエーション" do
    context "user に属している場合" do
      let!(:user) { create(:user) }
      let!(:shortcut) { create(:shortcut, user: user) }

      it "user と関連付いていること" do
        expect(shortcut.user).to eq(user)
      end
    end
  end
end
