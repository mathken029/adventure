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

### NPCと会話画面 (`scripts/npc.gd`, `scripts/dialogue_box.gd`)
- `NPC` (`class_name NPC`, `StaticBody2D`): プレイヤーと同じスプライト仕様(32x32, 3列x4行)だが別配色のスプライトシート `assets/sprites/npc.png` を使用する静止キャラクター。`character_name` と `lines`(セリフの配列)を持つ。当たり判定はプレイヤーと同じ `RectangleShape2D` (14x10)。
- `DialogueBox` (`class_name DialogueBox`, `Control`): 画面下部に表示する会話ウィンドウ。`start(speaker, lines)` で会話を開始し、`advance()` で次のセリフに進む。最後のセリフの次で非表示になり `is_active()` が `false` を返す。
- 会話の開始/進行は `Main` がプレイヤーとNPCの距離(`INTERACT_RANGE` = 24px)と決定キー(E / Space / Enter のいずれか、押した瞬間のみ反応)を見て制御する。会話中は `Player.movement_enabled` を `false` にしてプレイヤー移動を止める。

### メインシーン (`scripts/main.gd`)
- `GameWorld` / `Player` / `NPC` をインスタンス化して配置し、`CanvasLayer` 上に `DialogueBox` と `TouchControls` を1つずつ用意する。
- `Camera2D` をプレイヤーの子として追加し、ズーム2.5倍・マップ範囲でリミットを設定してプレイヤーに追従する。
- `_process` で決定キーの押下エッジを検出し、`_do_interact()` で会話の開始/進行とプレイヤー移動の有効/無効を切り替える。`TouchControls.interact_pressed` シグナルからも同じ `_do_interact()` を呼び出す。

### スマホ向けタッチ操作 (`scripts/touch_controls.gd`, `class_name TouchControls`)
- `CanvasLayer` (`layer=10`)。`DisplayServer.is_touchscreen_available()` がtrueの端末(スマホ等)でのみ表示する。
- 画面左下に上下左右のボタンを十字状に配置し、押している間 `held` 辞書を更新して `current_vector()` で方向ベクトルを計算、`move_input_changed(vector)` シグナルで通知する。
- 画面右下に「話す」ボタンを配置し、押した瞬間に `interact_pressed` シグナルを発火する(NPCとの会話開始/進行に使用)。
- `Main` が `move_input_changed` を `Player.touch_input_vector` に反映し、キーボード入力とタッチ入力を合成する(`Player.get_input_vector`)。

## 素材
- `assets/sprites/player.png`: 主人公キャラクターの歩行スプライトシート(自動生成のドット絵、青系の配色)。
- `assets/sprites/npc.png`: NPC(村人)の歩行スプライトシート(自動生成のドット絵、オレンジ系の配色)。同じフレームレイアウトで配色のみ変えている。
- `assets/tiles/tileset.png`: 草原/道/壁/木のタイルセット(自動生成のドット絵)。
- `assets/fonts/KosugiMaru-Regular.ttf`: 日本語表示用フォント。`project.godot` の `gui/theme/custom_font` でプロジェクト全体のデフォルトフォントとして設定し、タイトル画面や会話ウィンドウの日本語が文字化け(いわゆる「トーフ」表示)しないようにする。

## テスト
- GUTテストを `test/` 配下に配置。`.gutconfig.json` で `dirs: ["res://test/"]` を指定。
- `test/test_player.gd`: 向き判定・歩行アニメーションのフレーム切り替えロジックを検証。
- `test/test_world.gd`: マップレイアウト生成(サイズ・外壁・パス配置)、通行可否判定を検証。
- `test/test_license_notices.gd`: ライセンス表記文言にGUT/unityroom/Kosugi Maru/MITの記載が含まれることを検証。
- `test/test_dialogue_box.gd`: 会話の開始/進行/終了の状態遷移(`is_active`/`current_line`)を検証。
- `test/test_touch_controls.gd`: 十字キーの押下状態から方向ベクトルを計算するロジックと `move_input_changed` シグナルの発火を検証。

## サードパーティライセンス
- GUT (`addons/gut`): MIT License, Copyright (c) 2018 Tom "Butch" Wesley
- unityroom SDK (`addons/unityroom_sdk`): MIT License, Copyright (c) 2026 Yusuke Nakada
- Kosugi Maru (`assets/fonts/KosugiMaru-Regular.ttf`): Apache License 2.0, The Kosugi Maru Project Authors
- 上記はリポジトリの `README.md` および、ゲーム内タイトル画面の「ライセンス表記」ダイアログの両方に記載する。
