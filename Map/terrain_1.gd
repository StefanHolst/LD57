extends Node3D

@onready var HQ: Node3D = $Headquarter;

func _ready() -> void:
	Map.HQ = HQ;
