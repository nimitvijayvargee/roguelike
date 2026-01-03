extends Node2D

@export var radius := 48.0
@export var damage := 5

func _ready():
	await get_tree().create_timer(0.3).timeout
	queue_free()
	print("EXPLOSION READY")
	print($GPUParticles2D)
