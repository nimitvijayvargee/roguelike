extends CharacterBody2D

const ACCEL = 15000;
const MAX_SPEED = 900;
var stats = {
	"coins" = 0,
	"health" = 100
}
func _physics_process(delta: float) -> void:
	var input = Vector2(Input.get_axis("ui_left", "ui_right") , Input.get_axis("ui_up", "ui_down")).normalized()
		
	if input != Vector2.ZERO: velocity += input * ACCEL * delta
	else:
		if velocity.x > 0:
			velocity.x = max(velocity.x - ACCEL * delta, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + ACCEL * delta, 0)

		if velocity.y > 0:
			velocity.y = max(velocity.y - ACCEL * delta, 0)
		elif velocity.y < 0:
			velocity.y = min(velocity.y + ACCEL * delta, 0)
		
	if velocity.length() > MAX_SPEED: velocity = input * MAX_SPEED
	
	move_and_slide()


func _process(delta: float) -> void:
	pass
