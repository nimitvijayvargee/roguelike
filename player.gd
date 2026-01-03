extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://projectile.tscn")
const SPEED = 900.0
const ACCEL = 300.0
const DECEL = 15.0
var can_attack = true



# Projectile Properties
var projectile_properties = {
	"WAIT_TIME" = 0.1,
 	"PROJECTILE_SPEED" = 1600,
 	"PROJECTILE_DAMAGE" = 2,
 	"EXPLOSION_RADIUS" = 100 #pixels
}



func _physics_process(_ddelta: float) -> void:

	var input := Vector2(
	Input.get_axis("ui_left", "ui_right"),
	Input.get_axis("ui_up", "ui_down")
)	
	input = input.normalized()
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * SPEED, ACCEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECEL)
	
	shoot()
	move_and_slide()

func shoot():
	if can_attack:
		can_attack = false
		get_tree().create_timer(projectile_properties["WAIT_TIME"]).timeout.connect(func(): can_attack = true)
		
		var input_x = Input.get_axis("shoot_left", "shoot_right")
		var input_y = Input.get_axis("shoot_up", "shoot_down")

		if input_x != 0 or input_y != 0:
			var instance = projectile.instantiate()
			
			
			
			for key in projectile_properties:
				instance[key] = projectile_properties[key]
			
			get_parent().add_child(instance)
			if input_x != 0:
				instance.global_position = global_position + Vector2(67 * input_x, 0)
			elif input_y != 0:
				instance.global_position = global_position + Vector2(0, 67 * input_y)
		else: return
		
		
	


		
