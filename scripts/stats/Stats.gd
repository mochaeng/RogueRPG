extends Node

export(int) var max_health = 1


signal no_health


onready var health = max_health setget set_health


func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
