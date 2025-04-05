extends Node3D

var map = Map.new()

func _ready() -> void:
	for tower in map.towers:
		print(tower)
		self.add_child(tower)
