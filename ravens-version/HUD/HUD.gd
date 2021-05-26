extends CanvasLayer

signal start_game

# show a message and start the timer
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# show game over message and reset game
func show_game_over():
	show_message("Game over!")
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the\nRavens!"
	$Message.show()
	
	yield(get_tree().create_timer(1), "timeout") # one shot timer
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# Send start signal after button pressed
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

# Hide current message after timeout
func _on_MessageTimer_timeout():
	$Message.hide()
