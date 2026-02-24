extends CharacterBody2D

@export var speed = 300

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down"))
	velocity = direction * speed
	move_and_slide()
	
