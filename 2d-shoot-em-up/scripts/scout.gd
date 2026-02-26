extends Area2D
const ENEMY_LASER = preload("res://scenes/f-projectile.tscn")

var health: int = 2
var speed: float = 100.0
var velocity = Vector2(1, 0)
var direction: int = 0  # 0 = not set, 1 = right, -1 = left

@onready var anim = $AnimatedSprite2D
@onready var visible_notifier = $VisibleOnScreenNotifier2D
@export var fire_rate: float = 2.0
var shoot_timer: float = 0.0

func _ready() -> void:
	# Use the direction set by main.gd, or randomize if not set
	if direction == 0:
		direction = 1 if randf() > 0.5 else -1
	
	velocity.x = direction
	
	# Flip sprite based on direction
	if direction < 0:
		anim.flip_h = true

func _process(delta: float) -> void:
	position += velocity * speed * delta
	
	var screen_size = get_viewport_rect().size
	
	# Destroy when off screen (left or right depending on direction)
	if direction > 0 and position.x > screen_size.x + 50:
		queue_free()
	elif direction < 0 and position.x < -50:
		queue_free()
		
	shoot_timer += delta
	if shoot_timer >= fire_rate:
		shoot()
		shoot_timer = 0.0

func shoot():
	if health > 0 and visible_notifier.is_on_screen():
		var laser = ENEMY_LASER.instantiate()
		# Shoot downward toward the player
		laser.direction = Vector2.DOWN
		laser.global_position = global_position
		add_sibling(laser)

func _on_area_entered(area: Area2D) -> void:
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

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)

	health = 0
	speed = 0
	anim.play("Death")
	await anim.animation_finished
	queue_free()
