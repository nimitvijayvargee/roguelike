extends TileMapLayer

var PLAYER
var READY = 0

func _ready() -> void:
	PLAYER = get_tree().current_scene.get_node("Player")

func _process(_delta: float) -> void:
	print(get_child_count())
	if get_child_count() == 2 && $Item.text != "Try to shoot! The confetti cannon does not use ammo!":
		$Item.text = "Try to shoot! The confetti cannon does not use ammo!"
		READY = 1
	
func _input(_ev) -> void:
	if Input.is_action_just_pressed("next_room") && READY == 1:
		PLAYER.remove_effect("CONFETTI")
		PLAYER.load_room("res://rooms/room1/room1.tscn")
