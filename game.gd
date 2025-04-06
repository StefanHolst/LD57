extends Node3D

var map = Map.new(self)

func _ready() -> void:
	map.add_to_scene()
	Player.IngameMenu = find_child("IngameMenu")
	Player.ready()

func _process(_delta: float) -> void:
	map.move_units(_delta)
	map.towers_attack()
