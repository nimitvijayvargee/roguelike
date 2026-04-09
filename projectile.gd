extends CharacterBody2D

var SPEED = 1750
var DIRECTION = Vector2(0,0).normalized()

func _physics_process(delta: float) -> void:
	velocity = SPEED * DIRECTION
	move_and_slide()
