extends CharacterBody2D

@export var SPEED = 1000
var spawnPos : Vector2



func _ready() -> void:
	var x_dir = Input.get_axis("shoot_left", "shoot_right")
	var y_dir = Input.get_axis("shoot_up", "shoot_down")
	
	if x_dir != 0:
		velocity.x = x_dir * SPEED
	else:
		velocity.y = y_dir * SPEED

func _physics_process(delta: float) -> void:
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is TileMapLayer:
			queue_free()
	
