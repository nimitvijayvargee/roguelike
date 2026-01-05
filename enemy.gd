extends CharacterBody2D

var HEALTH := 20
var MAX_HEALTH := 20

var DAMAGE := 20
var CONTACT_DAMAGE := 10

@onready var explosion = preload("res://explosion.tscn")

func _ready() -> void:
	$ProgressBar.max_value = MAX_HEALTH
	


func _process(_delta: float) -> void:
	$ProgressBar.value = HEALTH
	if HEALTH == MAX_HEALTH:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true

func damage(amount: int, projectile: CharacterBody2D) -> void:
	print("DAMAGED ", amount)
	HEALTH -= amount
	if HEALTH <= 0:
		kill_self(projectile)
	

func kill_self(projectile: CharacterBody2D) -> void:
	
	var e = explosion.instantiate()
	e.global_position = global_position
	
	var mat := e.process_material as ParticleProcessMaterial
	mat.color = Color(projectile["EXPLOSION_COLOR"])
	mat.hue_variation_min = projectile["EXPLOSION_COLOR_HUE_MIN"]
	mat.hue_variation_max = projectile["EXPLOSION_COLOR_HUE_MAX"]
	
	
	get_parent().add_child(e)
	e.restart()
	
	queue_free()
