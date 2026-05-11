extends Node

@onready var debug_hud = preload("res://scenes/dev/debug_hud.tscn")
@onready var game_trash = preload("res://prefabs/components/trash.tscn")

## Global.gd autoload

const TILE_SIZE: int = 16

var version: String = "1.0.0"

var settings: Dictionary = {
	"window_mode": Window.MODE_WINDOWED,
	"window_size": Vector2i(1280, 720),
}
## Settings utility functions
func get_user_settings() -> Dictionary:
	#var config_file: ConfigFile #Was commented to skip warning messages while debugging
	var user_settings: Dictionary
	# To do
	# Retrieve user config file and set settings
	return user_settings

func get_default_settings() -> Dictionary:
	return {
		"window_mode": Window.MODE_WINDOWED,
		"window_size": Vector2i(1280, 720),
	}

func apply_settings() -> void:
	DisplayServer.window_set_mode(settings.window_mode)
	if settings.window_mode == Window.MODE_WINDOWED:
		DisplayServer.window_set_size(settings.window_size)

func _ready() -> void:
	if OS.has_feature("debug"):
		add_child(debug_hud.instantiate())
	
	add_child(game_trash.instantiate())
