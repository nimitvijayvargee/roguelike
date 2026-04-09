extends CharacterBody2D

var ACCEL = 15000
var SPEED = 400

var MAX_HEALTH = 150.00
var health = MAX_HEALTH

@onready var nav_agent = $NavigationAgent2D
@onready var PLAYER = get_parent().get_child(1)

func _ready() -> void:
	nav_agent.target_position = PLAYER.global_position

func _process(_delta: float) -> void:
	if health <= 0: 
		$Explosion.emitting = true
		$Explosion.finished.connect($Explosion.queue_free)
		$Explosion.reparent(get_parent())
		
		queue_free()
		
	if health < MAX_HEALTH:
		$Health.visible = true
		$Health.value = round(100 * health / MAX_HEALTH)
		
func _physics_process(_delta: float) -> void:
	nav_agent.target_position = PLAYER.global_position
	velocity = global_position.direction_to(nav_agent.get_next_path_position()) * SPEED
	move_and_slide()

func damage(damage_amount:int) -> void:
	health -= damage_amount
	print(health)
