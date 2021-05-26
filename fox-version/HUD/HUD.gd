extends CanvasLayer

signal start_game
signal pause_game
signal quit_round
signal mute_audio
signal unmute_audio

var difficulty

func _ready():
	$MuteButton.hide()
	$QuitButton.hide()
	# Handle difficulty options
	difficulty = 2
	$DifficultyOption.add_item("Super Easy")
	$DifficultyOption.add_item("Easy")
	$DifficultyOption.add_item("Normal")
	$DifficultyOption.add_item("Hard")
	$DifficultyOption.add_item("Super Hard")
	$DifficultyOption.select(difficulty)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if !get_tree().paused:
			$QuitButton.show()
			emit_signal("pause_game")
		else:
			$QuitButton.hide()
			get_tree().paused = false

# show a message and start the timer
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# show game over message and reset game
func show_game_over(game_over_message):
	show_message(game_over_message)
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the foxes!"
	$Message.show()
	
	yield(get_tree().create_timer(1), "timeout") # one shot timer
	$StartButton.show()
	$DifficultyOption.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# Send start signal after button pressed
func _on_StartButton_pressed():
	$StartButton.hide()
	$DifficultyOption.hide()
	$MuteButton.show()
	emit_signal("start_game")

func _on_QuitButton_pressed():
	get_tree().paused = false
	$QuitButton.hide()
	emit_signal("quit_round")

# Hide current message after timeout
func _on_MessageTimer_timeout():
	$Message.hide()

func _on_MuteAudio_toggled(button_pressed):
	if button_pressed:
		emit_signal("mute_audio")
	else:
		emit_signal("unmute_audio")

func _on_DifficultyOption_item_selected(index):
	difficulty = index
