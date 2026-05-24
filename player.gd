extends Area2D

signal hit # 自訂 signal，撞到敵人時 emit

@export var speed: int = 400 # 每秒移動 400 像素
var screen_size: Vector2 # 螢幕大小（_ready 算出來）


func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide() # 開始先藏起來，等 Main 叫我才出現


func _process(delta: float) -> void:
	# --- 1. 讀方向鍵，組合成 velocity 向量 ---
	var velocity := Vector2.ZERO # 預設不動 (0, 0)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# --- 2. 有按方向 → 標準化 + 乘速度 + 播動畫 ---
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	# --- 3. 套用位移 + 限制在畫面內 ---
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# --- 4. 根據移動方向切換動畫 ---
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0 # 往左走鏡像翻轉
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # 往下時上下翻轉


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos: Vector2) -> void:
	position = pos
	show() # 顯示自己（_ready 那邊 hide()）
	$CollisionShape2D.disabled = false # 重新啟用碰撞