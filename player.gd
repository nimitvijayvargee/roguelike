extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://projectile.tscn")
const SPEED = 600.0
const DECEL = 15
var can_attack = true
const WAIT_TIME = 0.1
func _physics_process(delta: float) -> void:

	var input := Vector2(
	Input.get_axis("ui_left", "ui_right"),
	Input.get_axis("ui_up", "ui_down")
)

	if input != Vector2.ZERO:
		velocity = input * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECEL)
	
	shoot()
	move_and_slide()

func shoot():
	if can_attack:
		can_attack = false
		get_tree().create_timer(WAIT_TIME).timeout.connect(func(): can_attack = true)
		
		var input_x = Input.get_axis("shoot_left", "shoot_right")
		var input_y = Input.get_axis("shoot_up", "shoot_down")


		if input_x != 0:
			var instance = projectile.instantiate()
			get_parent().add_child(instance)
			instance.global_position = global_position + Vector2(67 * input_x, 0)
		elif input_y != 0:
			var instance = projectile.instantiate()
			get_parent().add_child(instance)
			instance.global_position = global_position + Vector2(0, 67 * input_y)
	


		
