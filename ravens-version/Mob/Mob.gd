extends RigidBody2D

export var min_speed = 150
export var max_speed = 250

func _physics_process(delta):
	# Flip the sprite horizontally in case the mob moves from right to left
	$AnimatedSprite.flip_h = linear_velocity.x < 0

func _on_VisibilityNotifier2D_screen_exited():
	# Delete mob on screen exit
	queue_free()
