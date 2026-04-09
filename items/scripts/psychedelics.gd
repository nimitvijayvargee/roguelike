extends Area2D

var Player;

func _ready() -> void:
	Player = get_parent().get_child(1)
	print(Player)

func _process(_delta) -> void:
	if Player in get_overlapping_bodies():
		if Player.effect("psychedelics", 20):
			$PickUp.play()
			$PickUp.reparent(get_parent())
			queue_free()
	
