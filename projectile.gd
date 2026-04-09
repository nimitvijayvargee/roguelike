extends CharacterBody2D

var SPEED = 1750
var DIRECTION = Vector2(0,0).normalized()
@onready var explosion_instance = load("res://assets/vfx/explosion.tscn")

func _ready() -> void:
	$SFXPew.play()
	$SFXPew.finished.connect($SFXPew.queue_free)
func _physics_process(delta: float) -> void:
	velocity = SPEED * DIRECTION
	var collision_info = move_and_collide(velocity * delta)

	if collision_info:
		if collision_info.get_collider() is TileMapLayer:
			$SFXWall.play()
			$SFXWall.finished.connect($SFXWall.queue_free)
			
		if collision_info.get_collider() is CharacterBody2D:
			collision_info.get_collider().damage(10)
			
		var e = explosion_instance.instantiate()
		
		get_tree().current_scene.add_child(e) # safer than get_parent()
		e.global_position = global_position   # more consistent visually
		e.emitting = true
		queue_free()
		
	
