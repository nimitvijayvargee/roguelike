extends Area2D

var Player;

func _ready() -> void:
	Player = get_parent().get_child(1)
	print(Player)

func _process(_delta) -> void:
	if Player in get_overlapping_bodies():
		print("PICK UP")
		
