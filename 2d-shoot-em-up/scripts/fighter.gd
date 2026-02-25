extends Area2D

var health: int = 3
var speed: float =  100.0
var velocity = Vector2(0,1)
var random_timer: float = 0.0
@onready var anim = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.x = randf_range(-1.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	random_timer -= delta
	if random_timer <= 0.0:
		# Pick a new random horizontal speed and direction
		velocity.x = randf_range(-1.0, 1.0)
		# Set the timer to wait a random amount of time (between 0.5 and 1.5 seconds) before changing again
		random_timer = randf_range(0.5, 1.5)
		
	position += velocity * speed * delta
	
	var screen_size = get_viewport_rect().size
	
	if position.x < 20 or position.x > screen_size.x - 20:
		velocity.x *= -1 
		position.x = clamp(position.x, 20, screen_size.x - 20) 
		
	if position.y > screen_size.y + 50:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		area.queue_free()
		if health > 0:
			health -= 1
			if health <= 0:
				speed = 0
				anim.play("Death")
				await anim.animation_finished
				queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if health > 0:
			health = 0
			speed = 0
			anim.play("Death")
			await anim.animation_finished
			queue_free()
