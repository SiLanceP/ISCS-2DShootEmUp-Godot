extends Area2D

var health: int = 3
var speed: float = 100.0
var velocity = Vector2(0,1)
var random_timer: float = 0.0

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	velocity.x = randf_range(-1.0, 1.0)

func _process(delta: float) -> void:
	random_timer -= delta
	if random_timer <= 0.0:
		velocity.x = randf_range(-1.0, 1.0)
		random_timer = randf_range(0.5, 1.5)
	position += velocity * speed * delta
	
	var screen_size = get_viewport_rect().size
	
	if position.x < 20 or position.x > screen_size.x - 20:
		velocity.x *= -1 
		position.x = clamp(position.x, 20, screen_size.x - 20) 

	if position.y > screen_size.y + 50:
		queue_free()

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
