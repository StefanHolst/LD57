extends Node3D


func _ready() -> void:
	Map.game = self
	Map.add_to_scene()
	Player.IngameMenu = find_child("IngameMenu")
	Player.ready()

func _process(_delta: float) -> void:
	Map.move_units(_delta)
	Map.towers_attack()
