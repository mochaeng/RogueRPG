extends Control

const MIN_VALUE = 20
const X_SOLVED = 0.05 

var max_hearts = 4 setget set_max_hearts
var hearts = 4 setget set_hearts

onready var player_stats = PlayerStats
onready var texture_progress: TextureProgress = $TextureProgress


func _ready():
	self.max_hearts =  player_stats.max_health
	self.hearts = player_stats.health
	player_stats.connect("health_changed", self, "set_hearts")
	player_stats.connect("max_health_changed", self, "set_max_hearts")


func set_hearts(value) -> void:
	hearts = clamp(value, 0, value)
	if texture_progress != null:
		texture_progress.value = (hearts / X_SOLVED) + MIN_VALUE


func set_max_hearts(value) -> void:
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
