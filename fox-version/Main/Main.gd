extends Node

export (PackedScene) var Mob
var score
var music_position
var audio_is_muted
var game_is_active
var mob_min_speed
var mob_max_speed
var default_mob_timer_wait_time

func _ready():
	randomize()
	music_position = 0.00
	default_mob_timer_wait_time = $MobTimer.wait_time

func game_over():
	game_is_active = false
	$Player.stop()
	# deletes all mobs
	get_tree().call_group("mobs", "queue_free")
	# handles audio
	play_deathsound()
	# timers and user interface prompt
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over("Game over")
	$MobTimer.wait_time = default_mob_timer_wait_time

func new_game():
	game_is_active = true
	set_game_difficulty()
	# handles audio
	play_music()
	# starts the player's scene
	$Player.start($StartPosition.position)
	# timers and user interface prompts
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$StartTimer.start()

func set_game_difficulty():
	var game_difficulty = $HUD.difficulty
	mob_min_speed = (game_difficulty+1) * 75
	mob_max_speed = (game_difficulty+1) * 75
	if game_difficulty < 3 :
		$MobTimer.wait_time = default_mob_timer_wait_time + (2 - game_difficulty)
	if game_difficulty == 3:
		$MobTimer.wait_time = default_mob_timer_wait_time / 1.5
	if game_difficulty == 4:
		$MobTimer.wait_time = default_mob_timer_wait_time / 2

func _on_HUD_pause_game():
	get_tree().paused = true

func _on_StartTimer_timeout():
	if game_is_active:
		$MobTimer.start()
		$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# Pick random location on path2d
	$MobPath/MobSpawnLocation.offset = randi()
	# Create mob instance
	var mob = Mob.instance()
	add_child(mob)
	# Set mob direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Choose random mob location and random direction
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI/4, PI/4)
	# Set random velocity (speed + direction)
	mob.linear_velocity = Vector2(rand_range(mob_min_speed+mob_min_speed, mob_max_speed+mob_max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


##### AUDIO #####

func play_music():
	if !audio_is_muted:
		stop_deathsound()
		$Music.play(music_position)

func play_deathsound():
	if !audio_is_muted:
		stop_music()
		music_position = 0.00
		$DeathSound.play()

func stop_music():
	music_position = $Music.get_playback_position()
	$Music.stop()
	
func stop_deathsound():
	$DeathSound.stop()

func _on_HUD_unmute_audio():
	if game_is_active:
		play_music()
	audio_is_muted = false

func _on_HUD_mute_audio():
	if game_is_active:
		stop_music()
	else:
		stop_deathsound()
	audio_is_muted = true
