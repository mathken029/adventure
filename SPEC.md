# SPEC

## 概要
RPGツクール風の見下ろし型(トップダウン)アドベンチャーゲーム。Godot 4.7 / GDScriptで開発する。

## タイトル画面 (`scenes/title_screen.tscn`, `scripts/title_screen.gd`)
- 起動時に表示される仮のタイトル画面。`project.godot` の `run/main_scene` に設定。
- 表示要素:
  - タイトルラベル(仮題)
  - 「スタート」ボタン: `scenes/main.tscn` に遷移する
  - 「ライセンス表記」ボタン: `addons/` 内ライブラリ(GUT, unityroom SDK)のMITライセンス表記をダイアログで表示する
- ライセンス文言は `scripts/license_notices.gd` (`LicenseNotices`) に集約する。

## 見下ろし移動プロトタイプ (`scenes/main.tscn`)
### プレイヤー (`scripts/player.gd`, `class_name Player`)
- `CharacterBody2D` ベース。移動速度 100px/s。
- 入力: 矢印キー(`ui_left/right/up/down`)、およびWASD(`KEY_W/A/S/D`)の両対応。
- 向き(`facing`): DOWN/LEFT/RIGHT/UP の4方向。入力ベクトルの支配的な軸で向きを決定する(`update_facing`)。
- 歩行アニメーション: スプライトシート `assets/sprites/player.png` (32x32, 3列(アイドル/左足/右足) x 4行(下/左/右/上)) を `hframes=3, vframes=4` で使用。移動中は `WALK_FRAME_TIME`(0.15秒)ごとにフレーム列を `[1,0,2,0]` の順で切り替える(`current_walk_column`)。
- 当たり判定: `RectangleShape2D` (14x10) をキャラ下部に配置。

### マップ (`scripts/world.gd`, `class_name GameWorld`)
- 1枚の固定マップ(既定 20x15タイル、タイルサイズ16px)をコードで生成する。
- タイル種別: `GRASS` / `PATH` / `WALL` / `TREE` の4種。周囲は `WALL` で囲み、中央に横一直線の `PATH`、内部に `TREE` を障害物として配置。
- タイルセットは `assets/tiles/tileset.png` (16x16タイル4種を横に並べたアトラス) から `TileSet`/`TileSetAtlasSource` を実行時に構築する。`WALL`/`TREE` には物理衝突ポリゴンを付与し、`CharacterBody2D` が通過できないようにする。
- `is_walkable(cell)` でGRASS/PATHのみ通行可能と判定できる(将来のイベント配置等で利用)。

### メインシーン (`scripts/main.gd`)
- `GameWorld` と `Player` をインスタンス化して配置。
- `Camera2D` をプレイヤーの子として追加し、ズーム2.5倍・マップ範囲でリミットを設定してプレイヤーに追従する。

## 素材
- `assets/sprites/player.png`: キャラクター歩行スプライトシート(自動生成のドット絵)。
- `assets/tiles/tileset.png`: 草原/道/壁/木のタイルセット(自動生成のドット絵)。

## テスト
- GUTテストを `test/` 配下に配置。`.gutconfig.json` で `dirs: ["res://test/"]` を指定。
- `test/test_player.gd`: 向き判定・歩行アニメーションのフレーム切り替えロジックを検証。
- `test/test_world.gd`: マップレイアウト生成(サイズ・外壁・パス配置)、通行可否判定を検証。
- `test/test_license_notices.gd`: ライセンス表記文言にGUT/unityroom/MITの記載が含まれることを検証。

## サードパーティライセンス
- GUT (`addons/gut`): MIT License, Copyright (c) 2018 Tom "Butch" Wesley
- unityroom SDK (`addons/unityroom_sdk`): MIT License, Copyright (c) 2026 Yusuke Nakada
- 上記はリポジトリの `README.md` および、ゲーム内タイトル画面の「ライセンス表記」ダイアログの両方に記載する。
