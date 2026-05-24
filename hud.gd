extends CanvasLayer

signal start_game # 通知 Main：玩家按 START 了


func show_message(text: String) -> void:
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Game Over")
	await $MessageTimer.timeout # 等 2 秒訊息消失
	$MessageLabel.text = "Dodge the Creeps!"
	$MessageLabel.show()
	await get_tree().create_timer(1.0).timeout # 再等 1 秒
	$StartButton.show()


func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


# --- signal handlers ---

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()

func _on_start_game() -> void:
	pass # Replace with function body.
