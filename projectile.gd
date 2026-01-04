extends CharacterBody2D


var WAIT_TIME: float
var PROJECTILE_SPEED: float
var PROJECTILE_DAMAGE: int
var EXPLOSION_RADIUS: float
var EXPLOSION_DAMAGE: float


var PLAYER: CharacterBody2D

@onready var explosion = load("res://explosion.tscn")

func _ready() -> void:
	var x_dir = Input.get_axis("shoot_left", "shoot_right")
	var y_dir = Input.get_axis("shoot_up", "shoot_down")
	PLAYER = get_tree().current_scene.get_node("Player")

	if x_dir != 0:
		velocity.x = x_dir * PROJECTILE_SPEED
	else:
		velocity.y = y_dir * PROJECTILE_SPEED
	

func _physics_process(_delta: float) -> void:
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is TileMapLayer:
			explode()

func explode():
	var e = explosion.instantiate()
	e.global_position = global_position
	get_parent().add_child(e)
	e.restart()
	queue_free()
