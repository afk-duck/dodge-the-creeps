extends RigidBody2D

export var min_speed = 50
export var max_speed = 100

func _physics_process(delta):
	var y_positive = (linear_velocity.y * linear_velocity.y) / linear_velocity.y
	var x_positive = (linear_velocity.x * linear_velocity.x) / linear_velocity.x
	if x_positive <= y_positive:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = linear_velocity.x < 0
	if y_positive < x_positive:
		if linear_velocity.y < 0:
			$AnimatedSprite.animation = "up"
		if linear_velocity.y > 0:
			$AnimatedSprite.animation = "down"

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
