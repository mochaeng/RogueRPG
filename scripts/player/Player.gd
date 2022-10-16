extends KinematicBody2D
class_name Player

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

enum {
	MOVE,
	ATTACK
}

var velocity: Vector2 = Vector2.ZERO
var current_state = MOVE
var player_stats = PlayerStats

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var sword_hitbox_collision: CollisionShape2D = $SwordHitBox/CollisionShape2D
onready var sword_hitbox: Area2D = $SwordHitBox
onready var hurtbox: HurtBox = $HurtBox


func _ready():
	player_stats.connect("no_health", self, "queue_free")


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	match current_state:
		MOVE:
			move(delta, input_vector)
		ATTACK:
			attack(input_vector)


func move(delta, input_vector: Vector2) -> void:
	if input_vector != Vector2.ZERO:
		_split_sprite(input_vector)
		animation_player.play("move")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		sword_hitbox.knockback_vector = input_vector
	else:
		animation_player.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_pressed("ui_attack"):
		current_state = ATTACK

func attack(input_vector: Vector2) -> void:
	velocity = Vector2.ZERO
	_split_sprite(input_vector)
	animation_player.play("attack")


func _split_sprite(input_vector: Vector2):
	if input_vector.x > 0:
		sprite.flip_h = false
		sword_hitbox_collision.position = Vector2(10, 0)
	elif input_vector.x < 0:
		sprite.flip_h = true
		sword_hitbox_collision.position = Vector2(-10, 0)


func attack_finished() -> void:
	current_state = MOVE


func _on_HurtBox_area_entered(area):
	player_stats.health -= 1
	hurtbox.start_invinvibility(0.5)
	hurtbox.create_hit_effect()
	
