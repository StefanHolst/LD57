extends Node3D

var map = Map.new()

func _ready() -> void:
	map.add_to_scene(self)

func _process(_delta: float) -> void:
	map.move_units(_delta)
