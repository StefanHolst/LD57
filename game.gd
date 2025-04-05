extends Node3D

var map = Map.new(self)

func _ready() -> void:
	map.add_to_scene()

func _process(_delta: float) -> void:
	map.move_units(_delta)
	map.towers_attack()
