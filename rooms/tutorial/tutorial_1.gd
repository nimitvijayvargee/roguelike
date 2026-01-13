extends TileMapLayer

var PLAYER
func _ready() -> void:
	PLAYER = get_tree().current_scene.get_node("Player")

func _process(_delta: float) -> void:
	if get_child_count() == 2 && $WASD.text != "Press X to proceed to the next room!":
		$WASD.text = "Press X to proceed to the next room!"
	
	
func _input(ev) -> void:
	if Input.is_action_just_pressed("next_room") && get_child_count() == 2:
		PLAYER.load_room("res://rooms/tutorial/tutorial2.tscn")
