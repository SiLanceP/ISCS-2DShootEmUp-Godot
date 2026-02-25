extends CharacterBody2D

@export var speed = 300
@export var fire_rate = 0.2
@export var health: int = 5 
var fire_timer: float = 0.0
var is_dying: bool = false

@onready var anim = $AnimatedSprite2D 
const PROJECTILE = preload("uid://d337ap0wrf3wp")

func _process(delta: float) -> void:
	var move = Input.get_vector("left", "right", "up", "down")
	if move:
		velocity = move * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

	var screen_size = get_viewport_rect().size
	var padding = 20
	global_position.x = clamp(global_position.x, padding, screen_size.x - padding)
	global_position.y = clamp(global_position.y, padding, screen_size.y - padding)
	
	# Firing logic
	if fire_timer > 0.0:
		fire_timer -= delta
	if Input.is_action_pressed("shoot") and fire_timer <= 0.0:
		shoot()
		fire_timer = fire_rate

func shoot() -> void:
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = global_position
	add_sibling(new_projectile)

func _on_area_entered(area: Area2D) -> void:
	area.queue_free() 

	if health > 0:
		health -= 1
		if health <= 0:
			speed = 0
			set_deferred("monitoring", false)
			set_deferred("monitorable", false)
			anim.play("Death")
			await anim.animation_finished
			queue_free()
		else:
			anim.play("Hit") 
			await get_tree().create_timer(0.1).timeout
			if health > 0:
				anim.play("Normal")

func take_damage(amount: int):
	if is_dying: return
	
	health -= amount
	print("Player Health: ", health)
	
	if health <= 0:
		is_dying = true
		die()
	else:
		anim.play("Hit")
		await get_tree().create_timer(0.1).timeout
		if !is_dying:
			anim.play("Normal")

func die():
	set_process(false)
	$CollisionPolygon2D.set_deferred("disabled", true) 
	anim.play("Death")
	print("Playing Death Animation...")
	await anim.animation_finished
	get_tree().reload_current_scene()
