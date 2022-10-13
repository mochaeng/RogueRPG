extends KinematicBody2D

var ACCELERATION: int = 500
var MAX_SPEED: int = 80
var FRICTION: int = 500

var velocity: Vector2 = Vector2.ZERO

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		_split_sprite(input_vector)
		animation_player.play("move")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_player.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)

func _split_sprite(input_vector: Vector2):
	if input_vector.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true	
