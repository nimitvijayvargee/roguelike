extends CharacterBody2D

var HEALTH := 200
var MAX_HEALTH := 200 

var DAMAGE := 20
var CONTACT_DAMAGE := 10

var SPEED = 200
var PLAYER
var CONTACT_COUNTER = 0
@onready var explosion = preload("res://explosion.tscn")

func _ready() -> void:
	$ProgressBar.max_value = MAX_HEALTH
	PLAYER = get_tree().current_scene.get_node("Player")


func _process(_delta: float) -> void:
	$ProgressBar.value = HEALTH
	if HEALTH == MAX_HEALTH:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true



func _physics_process(delta: float) -> void:
	if is_instance_valid(PLAYER):
		var dir = (PLAYER.global_position - global_position).normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

		
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() == PLAYER:
			CONTACT_COUNTER += delta
			if CONTACT_COUNTER >= 0.5:
				PLAYER.damage(CONTACT_DAMAGE)
				CONTACT_COUNTER = 0
			
func damage(amount: int, projectile: CharacterBody2D) -> void:
	HEALTH -= amount
	if HEALTH <= 0:
		kill_self(projectile)
	

func kill_self(projectile: CharacterBody2D) -> void:
	
	var e = explosion.instantiate()
	e.global_position = global_position
	
	var mat := e.process_material.duplicate() as ParticleProcessMaterial
	e.process_material = mat
	mat.color = Color(projectile["EXPLOSION_COLOR"])
	mat.hue_variation_min = projectile["EXPLOSION_COLOR_HUE_MIN"]
	mat.hue_variation_max = projectile["EXPLOSION_COLOR_HUE_MAX"]
	mat.initial_velocity_min *= 0.3
	mat.initial_velocity_max *= 0.3
	mat.scale_min *= 2
	mat.scale_max *= 2
	mat.emission_sphere_radius *= 2
	
	e.amount = 40
	
	
	get_parent().add_child(e)
	e.restart()
	
	queue_free()
