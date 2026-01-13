extends CharacterBody2D

var PLAYER
@onready var CoinSFX = $CoinSFX
func _ready() -> void:
	PLAYER = get_tree().current_scene.get_node("Player")

func _physics_process(_delta: float) -> void:
	var distanceV := (position - PLAYER.position) as Vector2
	var distance := distanceV.length() as float
	if distance < 200:
		var dir = distanceV.normalized()
		velocity = -100 * dir
	else:
		velocity = Vector2.ZERO
	if distance < 150:
		CoinSFX.reparent(get_parent())
		CoinSFX.play()
		queue_free()
	move_and_slide()
