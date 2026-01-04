extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://projectile.tscn")

var can_attack = true

var player_stats = {
	"HEALTH" = 100,
	"MAX_HEALTH"=100,
	
	"PROJECTILE_REMAINING" = 250,
	"PROJECTILE_LIMIT" = 250, # Kinda like a stamina bar?
	
	"SPEED" = 900.0,
	"ACCEL" = 300.0,
	"DECEL" = 15.0
}

var player_active_effects = []
# Projectile Properties
var projectile_properties = {
	"WAIT_TIME" = 0.1,
 	"PROJECTILE_SPEED" = 1600,
 	"PROJECTILE_DAMAGE" = 2,
 	"EXPLOSION_RADIUS" = 100 #pixels
}


func _ready() -> void:
	$Camera2D/HealthBar.max_value = player_stats["MAX_HEALTH"]
	$Camera2D/StaminaBar.max_value = player_stats["PROJECTILE_LIMIT"]
	set_bars()
	
func _physics_process(_ddelta: float) -> void:

	var input := Vector2(
	Input.get_axis("ui_left", "ui_right"),
	Input.get_axis("ui_up", "ui_down")
)	
	input = input.normalized()
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * player_stats["SPEED"], player_stats["ACCEL"])
	else:
		velocity = velocity.move_toward(Vector2.ZERO, player_stats["DECEL"])
	
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
			player_stats["PROJECTILE_REMAINING"] -= 1
			set_bars()
			
			if player_stats["PROJECTILE_REMAINING"] == 200:
				player_stats["SPEED"] *= -1
		else: return
		
func set_bars():
	$Camera2D/HealthBar.value = player_stats["HEALTH"]
	$Camera2D/StaminaBar.value = player_stats["PROJECTILE_REMAINING"]
	$Camera2D/HealthBar/Label.text = str(player_stats["HEALTH"]) + "/" + str(player_stats["MAX_HEALTH"])
	$Camera2D/StaminaBar/Label.text = str(player_stats["PROJECTILE_REMAINING"]) + "/" + str(player_stats["PROJECTILE_LIMIT"])
	
func set_player_property(property, value) -> void:
	player_stats[property] = value
		
