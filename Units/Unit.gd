class_name Unit extends CharacterBody3D

@onready var healthBar: ProgressBar = find_child("HealthBar");

# Properties
var max_health: float
var health: float
var speed: float # how many times the unit can move in a second
var damage: float

var upgrade_cost: int
var upgrade_health: int
var upgrade_speed: int

var cost: int
var sell_value: int

var current_route_index: int = 0

func stun(duration: float) -> void:
	push_error("Abstract method 'stun' must be implemented by subclass.")

func _init() -> void:
	pass
