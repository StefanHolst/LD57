class_name Projectile extends Node3D

var target: Vector3

var speed: float

var map: Map

func _init(_map: Map) -> void:
	map = _map
