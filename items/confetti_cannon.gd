extends CharacterBody2D

var PLAYER
@onready var PowerUpSFX = $PowerUpSFX
func _ready() -> void:
	PLAYER = get_tree().current_scene.get_node("Player")

func _physics_process(delta: float) -> void:
	var distanceV := (position - PLAYER.position) as Vector2
	var distance := distanceV.length() as float
	if distance < 200:
		var dir = distanceV.normalized()
		velocity = -100 * dir
	else:
		velocity = Vector2.ZERO
	if distance < 100:
		PLAYER.add_effect("CONFETTI", 20)
		PowerUpSFX.reparent(get_parent())
		
		PowerUpSFX.play()
		queue_free()
	move_and_slide()
