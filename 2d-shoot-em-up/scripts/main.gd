extends Node2D

@onready var player_spawn = $Spawn
@onready var player = $Player

func _ready():
	player.global_position = player_spawn.global_position
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
