extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = preload("res://projectile.tscn")
@onready var effect_description = preload("res://effect.tscn")
@onready var explosion = preload("res://explosion.tscn")
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
var effect_nodes := {}

var projectile_properties := {
	"WAIT_TIME": 0.1,
	"PROJECTILE_SPEED": 1600,
	"PROJECTILE_DAMAGE": 2,
	
	"EXPLOSION_COLOR": "AD3F00",
	"EXPLOSION_COLOR_HUE_MIN":-0.2,
	"EXPLOSION_COLOR_HUE_MAX":0,
	
	"REGEN_TIME": 1.0,
	"REGEN_QUANTITY": 1,
	"REGEN_TICKER": 0.0
}

func _ready():
	$Camera/HealthBar.max_value = player_stats["MAX_HEALTH"]
	$Camera/StaminaBar.max_value = player_stats["PROJECTILE_LIMIT"]
	set_bars()
	#var scene := load("res://rooms/room1.tscn") as PackedScene
	#load_room(scene.instantiate())

func _input(_ev):
	if Input.is_action_pressed("spawn_enemy"):
		print("SPAWN")

func _physics_process(delta: float):
	var input := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(
			input * player_stats["SPEED"],
			player_stats["ACCEL"] * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			player_stats["DECEL"] * delta
		)

	shoot()
	move_and_slide()

func _process(delta: float):
	# tick effects
	for effect in player_active_effects.keys():
		player_active_effects[effect] -= delta
		update_effect_ui(effect)

		if player_active_effects[effect] <= 0:
			remove_effect(effect)

	# projectile regen
	projectile_properties["REGEN_TICKER"] += delta
	if projectile_properties["REGEN_TICKER"] >= projectile_properties["REGEN_TIME"]:
		player_stats["PROJECTILE_REMAINING"] = min(
			player_stats["PROJECTILE_REMAINING"] + projectile_properties["REGEN_QUANTITY"],
			player_stats["PROJECTILE_LIMIT"]
		)
		projectile_properties["REGEN_TICKER"] = 0.0
		set_bars()

func shoot():
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

	player_stats["PROJECTILE_REMAINING"] -= 1
	set_bars()

func set_bars():
	$Camera/HealthBar.value = player_stats["HEALTH"]
	$Camera/StaminaBar.value = player_stats["PROJECTILE_REMAINING"]
	$Camera/HealthBar/Label.text = str(player_stats["HEALTH"]) + "/" + str(player_stats["MAX_HEALTH"])
	$Camera/StaminaBar/Label.text = str(player_stats["PROJECTILE_REMAINING"]) + "/" + str(player_stats["PROJECTILE_LIMIT"])

func add_effect(effect: String, duration: float):
	player_active_effects[effect] = duration

	if effect == "CONFUSION":
		player_stats["SPEED"] = -abs(player_stats["SPEED"])
		
	elif effect == "CONFETTI":
		projectile_properties["EXPLOSION_COLOR"] = "#FF0000"
		projectile_properties["EXPLOSION_COLOR_HUE_MIN"] = -1
		projectile_properties["EXPLOSION_COLOR_HUE_MAX"] = 1
		
	var ui = effect_description.instantiate()
	$Camera/EffectUIHandler.add_child(ui)
	effect_nodes[effect] = ui

	ui.get_node("Duration").max_value = duration * 30
	ui.get_node("Description").bbcode_enabled = true

func update_effect_ui(effect: String):
	if not effect_nodes.has(effect):
		return

	var ui = effect_nodes[effect]
	var duration = player_active_effects[effect]

	ui.get_node("Duration").value = duration * 30
	var t := int(duration)
	@warning_ignore("integer_division")
	var mins := t / 60
	var secs := t % 60

	ui.get_node("Duration").get_node("Time").text = "[%02d:%02d]" % [mins, secs]
	if effect == "CONFUSION":
		ui.get_node("Description").text = build_effect_text("Confused", "don't trip!")
	elif effect == "CONFETTI":
		ui.get_node("Description").text = build_effect_text("Confetti", "party time!")

func remove_effect(effect: String):
	if effect_nodes.has(effect):
		effect_nodes[effect].queue_free()
		effect_nodes.erase(effect)

	player_active_effects.erase(effect)

	if effect == "CONFUSION":
		player_stats["SPEED"] = abs(player_stats["SPEED"])
	if effect == "CONFETTI":
		projectile_properties["EXPLOSION_COLOR"] = "#AD3F00"
		projectile_properties["EXPLOSION_COLOR_HUE_MIN"] = -0.2
		projectile_properties["EXPLOSION_COLOR_HUE_MAX"] = 0

func build_effect_text(title: String, description: String):
	return "[b]%s[/b]\n%s" % [title, description]

func damage(amount: int) -> void:
	player_stats["HEALTH"] -= amount
	set_bars()
	if player_stats["HEALTH"] <= 0:
		kill_self()

func kill_self() -> void:
	
	var e = explosion.instantiate()
	e.global_position = global_position
	
	var mat := e.process_material.duplicate() as ParticleProcessMaterial
	e.process_material = mat
	mat.color = Color(projectile_properties["EXPLOSION_COLOR"])
	mat.hue_variation_min = projectile_properties["EXPLOSION_COLOR_HUE_MIN"]
	mat.hue_variation_max = projectile_properties["EXPLOSION_COLOR_HUE_MAX"]
	mat.initial_velocity_min *= 0.3
	mat.initial_velocity_max *= 0.3
	mat.scale_min *= 2
	mat.scale_max *= 2
	mat.emission_sphere_radius *= 2
	
	e.amount = 40
	
	
	get_parent().add_child(e)
	e.restart()
	get_tree().create_timer(1).timeout.connect(
		func(): e.queue_free()
	)
	
	var cam := $Camera
	cam.get_parent().remove_child(cam)
	get_tree().current_scene.add_child(cam)
	cam.global_position = global_position
	
	queue_free()
	
	
func load_room(room: Node2D) -> void:
	main.add_child(room)
