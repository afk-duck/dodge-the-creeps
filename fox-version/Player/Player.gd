extends Area2D

signal hit

export var speed = 400
var screen_size

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos
#	target = pos # initial target is start position
	show()
	$CollisionShape2D.disabled = false

func stop():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _process(delta):
	var velocity = Vector2() # movement vector
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play() # plays the animation when player is moving
	else:
		$AnimatedSprite.stop() # stops the animation when player is not moving
	
	position += velocity * delta
	# clamp restricts position to a given range (within the defined screen size)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "sideways"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y < 0:
		$AnimatedSprite.animation = "up"
	if velocity.y > 0:
		$AnimatedSprite.animation = "down"

func _on_Player_body_entered(body):
	stop()
	emit_signal("hit")
