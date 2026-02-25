extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	translate(Vector2.DOWN * 30 * delta)
