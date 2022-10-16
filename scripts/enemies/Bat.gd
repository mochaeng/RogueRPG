extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

export(int) var ACCELERATION = 300
export(int) var MAX_SPEED = 50
export(int) var FRICTION = 200

const enemy_death_effect = preload("res://scenes/effects/EnemyDeathEffect.tscn")

var knockback: Vector2 = Vector2.ZERO
var current_state = IDLE
var velocity: Vector2 = Vector2.ZERO

onready var stats: Node = $Stats
onready var detection_zone: Area2D = $PlayerDetectionZone
onready var sprite: AnimatedSprite = $Sprite
onready var hurtbox: HurtBox = $HurtBox


func _ready():
	pass


func _physics_process(delta): 
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match current_state:
		IDLE:
			idle(delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player: Player = detection_zone.player
			if detection_zone.can_see_player():
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				current_state = IDLE
			sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)


func seek_player():
	if detection_zone.can_see_player():
		current_state = CHASE


func idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	var death_effect_instance = enemy_death_effect.instance()
	get_parent().add_child(death_effect_instance)
	death_effect_instance.global_position = global_position
