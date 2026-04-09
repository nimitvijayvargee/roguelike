extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(die)

func die() -> void:
	queue_free()
