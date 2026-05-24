extends Node

@export var mob_scene: PackedScene # ← 等下 Inspector 拖 mob.tscn 進來
var score: int = 0


func _ready() -> void:
	pass


func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Music.play()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


# --- Timer signal handlers ---

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	# 1. 隨機選路徑上的點
	var mob_spawn_location := $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() # 0~1 隨機，自動跳到路徑上

	# 2. instance 一隻 mob
	var mob = mob_scene.instantiate()

	# 3. 把 mob 擺到 spawn 位置 + 朝畫面內飛
	var direction = mob_spawn_location.rotation + PI / 2 # 切線方向 + 90度（朝內）
	direction += randf_range(-PI / 4, PI / 4) # 加點隨機角度
	mob.position = mob_spawn_location.position
	mob.rotation = direction

	# 4. 設速度（朝 direction 方向飛）
	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# 5. 加進場景樹
	add_child(mob)

func _on_player_hit() -> void:
	game_over()
	pass # Replace with function body.


func _on_hud_start_game() -> void:
	pass # Replace with function body.
