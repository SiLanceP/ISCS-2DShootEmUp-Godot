extends Area2D

var speed = 1250

func _process(delta: float) -> void:
	translate(Vector2.UP * speed * delta)

func _on_area_entered(area: Area2D) -> void:
	queue_free()
