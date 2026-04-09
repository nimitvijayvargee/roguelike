extends CharacterBody2D

const ACCEL = 15000;
const MAX_SPEED = 900;

var is_cooldown = false
const PROJECTILE = preload("res://projectile.tscn")
var PLAYER
@onready var nav_agent = $NavigationAgent2D

func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_nav_velocity_computed)
	nav_agent.navigation_finished.connect(_on_nav_finish)
	make_path(get_parent().get_child(0).global_position)
	
func _on_nav_finish():
	PLAYER = get_parent().get_child(0)
	
	
func _on_nav_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, ACCEL)
	
func make_path(pos: Vector2):
	nav_agent.target_position = pos
	

func _physics_process(delta: float) -> void:
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	var new_velocity = direction*MAX_SPEED
	
	nav_agent.velocity = new_velocity
	move_and_slide()
