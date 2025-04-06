class_name Headquarter extends Node3D

@export var HP: float = 1;

const height: int = 22;

func _process(_delta: float) -> void:
	position.y = -height * (1 - HP);
