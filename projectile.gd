extends CharacterBody2D


var WAIT_TIME: float
var PROJECTILE_SPEED: float
var PROJECTILE_DAMAGE: int
var EXPLOSION_RADIUS: float
var EXPLOSION_DAMAGE: float
var EXPLOSION_COLOR: String
var EXPLOSION_COLOR_HUE_MIN: float
var EXPLOSION_COLOR_HUE_MAX: float
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
		if col.get_collider() is TileMapLayer or CharacterBody2D:
			explode()
		if col.get_collider() is CharacterBody2D:
			col.get_collider().damage(PROJECTILE_DAMAGE, self)

func explode():
	var e = explosion.instantiate()
	e.global_position = global_position
	var mat := e.process_material as ParticleProcessMaterial
	mat.color = Color(EXPLOSION_COLOR)
	mat.hue_variation_min = EXPLOSION_COLOR_HUE_MIN
	mat.hue_variation_max = EXPLOSION_COLOR_HUE_MAX

	get_parent().add_child(e)
	e.restart()
	get_tree().create_timer(1).timeout.connect(
		func(): e.queue_free()
	)
	
	queue_free()
