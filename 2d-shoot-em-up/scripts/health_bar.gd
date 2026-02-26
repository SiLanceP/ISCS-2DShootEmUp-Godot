extends CanvasLayer

@export var max_health: int = 5
var current_health: int = 5

@onready var health_label = $HealthLabel
@onready var health_bar = $HealthBar

func _ready():
	update_health(max_health)

func update_health(health: int):
	current_health = health
	health_label.text = "Health: " + str(current_health) + "/" + str(max_health)
	
	# Update the progress bar
	if health_bar:
		var percentage = float(current_health) / float(max_health)
		health_bar.value = percentage * 100
