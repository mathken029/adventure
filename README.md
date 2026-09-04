# adventure

RPGツクール風の見下ろし型(トップダウン)アドベンチャーゲーム。Godot 4.7 / GDScriptで開発しています。

詳細な仕様は [SPEC.md](./SPEC.md) を参照してください。

## 開発

- テスト実行: `godot --headless -s res://addons/gut/gut_cmdln.gd`
- Webビルド: `godot --headless --export-release "Web" ./build/index.html`

## サードパーティライセンス

このプロジェクトは `addons/` 配下に以下のMITライセンスのライブラリを同梱しています。各ライセンスの全文は同梱の `LICENSE` ファイル、およびゲーム内タイトル画面の「ライセンス表記」ボタンからも確認できます。

### GUT (Godot Unit Test)

- リポジトリ内パス: `addons/gut`
- Copyright (c) 2018 Tom "Butch" Wesley
- License: MIT

### unityroom SDK for Godot

- リポジトリ内パス: `addons/unityroom_sdk`
- Copyright (c) 2026 Yusuke Nakada
- License: MIT

### Kosugi Maru (フォント)

- リポジトリ内パス: `assets/fonts/KosugiMaru-Regular.ttf`
- Source: https://github.com/google/fonts/tree/main/apache/kosugimaru
- Copyright: The Kosugi Maru Project Authors
- License: Apache License 2.0
