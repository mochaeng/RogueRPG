extends Area2D
class_name HurtBox

const hit_effect = preload("res://scenes/effects/HitEffect.tscn")

var is_invincible = false setget set_invinsible

signal invincibility_starded
signal invincibility_ended

onready var timer: Timer = $Timer


func create_hit_effect() -> void:
	var hit_effect_instance = hit_effect.instance()
	add_child(hit_effect_instance)
	hit_effect_instance.global_position = global_position


func start_invinvibility(duration: float) -> void:
	self.is_invincible = true
	timer.start(duration)


func set_invinsible(value: bool) -> void:
	is_invincible = value
	if is_invincible:
		emit_signal("invincibility_starded")
	else:
		emit_signal("invincibility_ended")


func _on_Timer_timeout() -> void:
	self.is_invincible = false


func _on_HurtBox_invincibility_starded():
	set_deferred("monitoring", false)


func _on_HurtBox_invincibility_ended():
	monitoring = true
