extends TileMapLayer

var PLAYER
var HEART
var AMMO_BOX 	
var READY = 0
func _ready() -> void:
	PLAYER = get_tree().current_scene.get_node("Player")
	HEART = load("res://items/heart.tscn")
	
func _process(_delta: float) -> void:
	print(get_child_count())
	if get_child_count() == 2 && $IJKL.text != "Press X to proceed to the next room!":
		$IJKL.text = "Nice work, here is some health and an ammo box to help you get ready!"
		if READY == 0:
			get_parent().add_child(HEART.instantiate())
			READY = 1
	
func _input(_ev) -> void:
	if Input.is_action_just_pressed("next_room") && READY == 1:
		PLAYER.load_room("res://rooms/tutorial/tutorial3.tscn")
