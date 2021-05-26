extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	# Delete all mobs at once on game over
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$DeathSound.stop()
	$Music.play()
	# Set player to the defined position
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_StartTimer_timeout():
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
	# Set velocity (speed + direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
