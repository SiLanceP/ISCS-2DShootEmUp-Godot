extends CharacterBody2D

@export var speed = 300
@export var fire_rate = 0.2
var fire_timer: float = 0.0
const PROJECTILE = preload("uid://d337ap0wrf3wp")

func _process(delta: float) -> void:
	var move = Input.get_vector("left","right","up","down")
	if move:
		velocity = move * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if fire_timer > 0.0:
		fire_timer -= delta
	if Input.is_action_pressed("shoot") and fire_timer <= 0.0:
		shoot()
		fire_timer = fire_rate

func shoot() -> void:
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = global_position
	add_sibling(new_projectile)
