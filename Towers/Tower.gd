class_name Tower extends Node3D

# Properties
var attack_range: float
var attack_damage: int
var attack_speed: float

var upgrade_cost: int
var upgrade_range: float
var upgrade_damage: int
var upgrade_attack_speed: float

var cost: int
var sell_value: int

func unit_in_range(unit):
	# Check if the unit is within range
	return position.distance_to(unit.position) <= attack_range
