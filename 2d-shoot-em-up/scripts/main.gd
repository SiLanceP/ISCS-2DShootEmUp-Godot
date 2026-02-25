extends Node2D

const FIGHTER_SCENE = preload("res://scenes/fighter.tscn")

@onready var player_spawn = $Spawn
@onready var player = $Player

func _ready():
	player.global_position = player_spawn.global_position
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_enemy_timer_timeout() -> void:
	var enemy = FIGHTER_SCENE.instantiate()
	var screen_size = get_viewport_rect().size
	var random_x = randf_range(50, screen_size.x - 50)
	enemy.global_position = Vector2(random_x, -50)
	add_child(enemy)
