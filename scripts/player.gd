extends CharacterBody2D

const ACCEL = 15000;
const MAX_SPEED = 900;

var is_cooldown = false
const PROJECTILE = preload("res://projectile.tscn")
var stats = {
	"coins" = 0,
	"health" = 100,
	"ammo" = 0,
	
	"max_health" = 100,
	"max_ammo" = 25
}

func _physics_process(delta: float) -> void:
	var input = Vector2(Input.get_axis("ui_left", "ui_right") , Input.get_axis("ui_up", "ui_down")).normalized()
		
	if input != Vector2.ZERO: velocity += input * ACCEL * delta
	else:
		if velocity.x > 0:
			velocity.x = max(velocity.x - ACCEL * delta, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + ACCEL * delta, 0) 

		if velocity.y > 0:
			velocity.y = max(velocity.y - ACCEL * delta, 0)
		elif velocity.y < 0:
			velocity.y = min(velocity.y + ACCEL * delta, 0)
		
	if velocity.length() > MAX_SPEED: velocity = input * MAX_SPEED
	
	if Input.is_action_pressed("shoot_down") or Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_right") or Input.is_action_pressed("shoot_up"):
		if not is_cooldown:
			var projectile = PROJECTILE.instantiate()
			get_parent().add_child(projectile)
			projectile.global_position = global_position
			is_cooldown = true

			var cooldown = Timer.new()
			cooldown.wait_time = 0.05
			cooldown.one_shot = true
			add_child(cooldown)
			cooldown.timeout.connect(bullet_cooldown_end)
			cooldown.start()
			
			if Input.is_action_pressed("shoot_down"): projectile.DIRECTION = Vector2(0,1).normalized()
			if Input.is_action_pressed("shoot_left"): projectile.DIRECTION = Vector2(-1,0).normalized()
			if Input.is_action_pressed("shoot_right"): projectile.DIRECTION = Vector2(1,0).normalized()
			if Input.is_action_pressed("shoot_up"): projectile.DIRECTION = Vector2(0,-1).normalized()

		
	move_and_slide()


func _process(_delta: float) -> void:
	$Camera/Health.value = stats["health"] * 100 / stats ["max_health"]
	$Camera/Ammo.value = stats["ammo"] * 100 / stats["max_ammo"]
	$Camera/Coins/Label.text = "Coins: " + str(stats["coins"])

func bullet_cooldown_end() -> void:
	is_cooldown = false
