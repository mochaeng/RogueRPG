extends Area2D

export(bool) var show_hit_effect = true

const hit_effect = preload("res://scenes/effects/HitEffect.tscn")


func _on_HurtBox_area_entered(area):
	if show_hit_effect:
		var hit_effect_instance = hit_effect.instance()
		add_child(hit_effect_instance)
		hit_effect_instance.global_position = global_position
