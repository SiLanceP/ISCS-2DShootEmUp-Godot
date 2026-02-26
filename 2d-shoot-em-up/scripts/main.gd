extends Node2D

const FIGHTER_SCENE = preload("res://scenes/fighter.tscn")
const SCOUT_SCENE = preload("res://scenes/scout.tscn")

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

func _on_scout_timer_timeout() -> void:
	var scout = SCOUT_SCENE.instantiate()
	var screen_size = get_viewport_rect().size
	# Spawn in top half of the screen (above player area)
	var random_y = randf_range(50, screen_size.y * 0.5)
	
	# Spawn from left or right side (50% chance)
	if randf() > 0.5:
		# Spawn from left, move right
		scout.direction = 1
		scout.global_position = Vector2(-50, random_y)
	else:
		# Spawn from right, move left
		scout.direction = -1
		scout.global_position = Vector2(screen_size.x + 50, random_y)
	
	add_child(scout)
