# ShortcutHub（ショートカットハブ）

### サービス URL：https://shortcuthub.jp/

<img src="/app/assets/images/ogp.png" width="50%" />

## 目次
- [サービス概要](#サービス概要)
- [開発背景](#開発背景)
- [機能紹介](#機能紹介)
- [使用技術](#使用技術)
- [インフラ構成図](#インフラ構成図)
- [ER図](#er-図)
- [画面遷移図](#画面遷移図)

## サービス概要
### iPhone ショートカットのレシピ共有プラットフォーム

- iPhone をより便利に使うことができる『ショートカット』を共有・ダウンロードできるプラットフォーム。
- 自分で作成したショートカットのタイトル、概要、使い方、ダウンロードリンクを投稿可能。
- 他の人が作ったショートカットをダウンロードリンクをタップすることでダウンロード可能。

## 開発背景
## このサービスへの思い・作りたい理由

- 趣味で iPhone の便利術やショートカットを活用した効率化について SNS で発信していく中で多くの反響を呼び（2025 年 4 月 1 日現在： SNS 総フォロワー 4.9 万人）、私自身が作成したショートカットが纏まっているサイトがあると便利とのユーザーからの声が多かったこと。
- 私の作ったショートカットだけでなく、もっと様々なショートカットを知りたいという声が多かったこと。
- 個人的に便利なショートカットを作成したものの、それを他者へ広めることに特化したプラットフォームがなかったこと。

## ユーザー層について

- iPhone のショートカットを活用して iPhone を便利に使いたい人。
- 自分で作ったショートカットを誰かに共有したい人。
  → 上記のサービスへの思いと重複しますが、iPhone の便利術などを発信していく中で、iPhone のショートカットをもっと知りたい方や、逆に自分で作ったものをシェアしたい方がいたから。

## サービスの利用イメージ

・私が作成したショートカットも含め、様々な便利なショートカットをダウンロードすることができ、iPhone をより便利に使うことができる。
・自分で作成したショートカットを他者へ共有でき、iPhone のショートカットに特化したプラットフォームだからこそ他の SNS で共有するよりも、多くの人に自分で作ったショートカットを使ってもらえる。

## ユーザーの獲得について

- 総フォロワー 5 万人超の SNS アカウントでの発信。([TikTok](https://www.tiktok.com/@mike_iphone?_t=ZS-8vA5wzuRCWQ&_r=1)、[YouTube](https://youtube.com/channel/UC5MKBFQFZ1kD9MIeo8DCr7g?si=uXPEtbOgAyH68KPv)、[Instagram](https://www.instagram.com/mikeneko_iphone?igsh=Mm5tbDJpNHZhcDY3&utm_source=qr))
- YouTube などのネット広告での宣伝。

## サービスの差別化ポイント・推しポイント

- 同様のプラットフォームは現状存在しませんが、ショートカットのまとめサイトは存在しており、そのサービスと比較すると様々なショートカットを検索して見つけることができる点や、自分で作ったショートカットを公開できるという点が優れています。

## 機能紹介

## 使用技術
| カテゴリ | 技術 | 
| --- | --- |
| フロントエンド | Ruby on Rails 7.2.1 / JavaScript | 
| バックエンド | Ruby on Rails 7.2.1 / Ruby 3.3.8 |
| データベース | PostgreSQL 15.5 |
| Web API | OpenAI API(GPT Image 1) / Google API |
| 開発環境 | Docker |
| CI/CD | Github Actions |
| インフラ | Render / Neon / AWS S3 |
| その他 | Tailwind CSS / daisyUI / <br> ESLint / rubocop / CarrierWave / mini magick |


## インフラ構成図

## 画面遷移図

Figma：https://www.figma.com/design/kLYQcceyEps8ZfeX1nv39J/Shortcut-Hub?node-id=0-1&t=DOCaIUfSgI7aYJBA-1

## ER 図

[![Image from Gyazo](https://i.gyazo.com/511073a11ab51319f7b10440624067a8.png)](https://gyazo.com/511073a11ab51319f7b10440624067a8)
