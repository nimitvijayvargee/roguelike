extends TileMapLayer

var PLAYER
var enemy_count
var READY = 0

func _ready() -> void:
	PLAYER = get_tree().current_scene.get_node("Player")
	
func _process(_delta) -> void:
	enemy_count = $Enemies.get_child_count()
	if enemy_count == 0 : READY = 1

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_room") && READY == 1:
		PLAYER.load_room("res://rooms/room2/room2.tscn")
