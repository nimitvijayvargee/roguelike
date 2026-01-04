extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://projectile.tscn")
@onready var effect_decription = load("res://effect.tscn/")

var can_attack := true

var player_stats := {
	"HEALTH": 100,
	"MAX_HEALTH": 100,

	"PROJECTILE_REMAINING": 250,
	"PROJECTILE_LIMIT": 250,

	"SPEED": 900.0,
	"ACCEL": 300.0 * 60,
	"DECEL": 15.0 * 60
}

var player_active_effects := {}

var projectile_properties := {
	"WAIT_TIME": 0.1,
	"PROJECTILE_SPEED": 1600,
	"PROJECTILE_DAMAGE": 2,
	"EXPLOSION_RADIUS": 100,
	
	"REGEN_TIME": 1,
	"REGEN_QUANTITY": 1,
	"REGEN_TICKER":0
}

func _ready() -> void:
	$Camera/HealthBar.max_value = player_stats["MAX_HEALTH"]
	$Camera/StaminaBar.max_value = player_stats["PROJECTILE_LIMIT"]
	set_bars()

func _physics_process(delta: float) -> void:
	var input := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * player_stats["SPEED"], player_stats["ACCEL"] * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, player_stats["DECEL"] * delta)

	shoot()
	move_and_slide()

func _process(delta):
	for effect in player_active_effects.keys():
		player_active_effects[effect] -= delta
		update_effect_ui()
		if player_active_effects[effect] <= 0:
			remove_effect(effect)
	
	projectile_properties["REGEN_TICKER"] += delta
	if projectile_properties["REGEN_TICKER"] >= projectile_properties["REGEN_TIME"]:
		player_stats["PROJECTILE_REMAINING"] = min(
			player_stats["PROJECTILE_REMAINING"]+projectile_properties["REGEN_QUANTITY"],
			player_stats["PROJECTILE_LIMIT"]
		)
		projectile_properties["REGEN_TICKER"] = 0
		set_bars()
	

func shoot() -> void:
	var input_x := Input.get_axis("shoot_left", "shoot_right")
	var input_y := Input.get_axis("shoot_up", "shoot_down")

	if input_x == 0 and input_y == 0:
		return

	if not can_attack:
		return

	if player_stats["PROJECTILE_REMAINING"] <= 0:
		return

	can_attack = false
	get_tree().create_timer(projectile_properties["WAIT_TIME"]).timeout.connect(
		func(): can_attack = true
	)

	var instance = projectile.instantiate()

	for key in projectile_properties:
		instance.set(key, projectile_properties[key])

	get_parent().add_child(instance)

	if input_x != 0:
		instance.global_position = global_position + Vector2(67 * sign(input_x), 0)
		instance.velocity = Vector2(sign(input_x), 0) * projectile_properties["PROJECTILE_SPEED"]
	else:
		instance.global_position = global_position + Vector2(0, 67 * sign(input_y))
		instance.velocity = Vector2(0, sign(input_y)) * projectile_properties["PROJECTILE_SPEED"]

	player_stats["PROJECTILE_REMAINING"] = max(
		player_stats["PROJECTILE_REMAINING"] - 1,
		0
	)
	set_bars()

	if player_stats["PROJECTILE_REMAINING"] == 200:
		add_effect("CONFUSION", 10.0)

func set_bars() -> void:
	$Camera/HealthBar.value = player_stats["HEALTH"]
	$Camera/StaminaBar.value = player_stats["PROJECTILE_REMAINING"]
	$Camera/HealthBar/Label.text = str(player_stats["HEALTH"]) + "/" + str(player_stats["MAX_HEALTH"])
	$Camera/StaminaBar/Label.text = str(player_stats["PROJECTILE_REMAINING"]) + "/" + str(player_stats["PROJECTILE_LIMIT"])

func set_player_property(property: String, value) -> void:
	player_stats[property] = value

func add_effect(effect: String, duration: float) -> void:
	player_active_effects[effect] = duration

	if effect == "CONFUSION":
		player_stats["SPEED"] = -abs(player_stats["SPEED"])

	get_tree().create_timer(duration).timeout.connect(
		func(): remove_effect(effect)
	)
	
	
func build_effect_text(title, description, time_left) -> String:
	var t := int(time_left)
	@warning_ignore("integer_division")
	var mins = t / 60
	var secs = t % 60

	return "[b]%s[/b] [i]%02d:%02d[/i]\n%s" % [
		title,
		mins,
		secs,
		description
	]
	
func remove_effect(effect: String) -> void:
	if effect in player_active_effects:
		player_active_effects.erase(effect)

	if effect == "CONFUSION":
		player_stats["SPEED"] = abs(player_stats["SPEED"])

func update_effect_ui():
	var text = ""
	
	for effect in player_active_effects:
		if effect == "CONFUSION" && player_active_effects[effect] >= 0:
			print(player_active_effects[effect])
			text += build_effect_text(
				"Confused",
				"Watch your step",
				player_active_effects[effect]
			) + "\n\n"
			
	$Camera/EffectUIHandler/Effect/Duration/Labeld.text = text
