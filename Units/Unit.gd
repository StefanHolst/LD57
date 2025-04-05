class_name Unit extends Node3D

# Properties
var health: int
var speed: float # how many times the unit can move in a second

var upgrade_cost: int
var upgrade_health: int
var upgrade_speed: int

var cost: int
var sell_value: int

var last_move: float = 0.0
func should_move():
	var speed_target = 1000.0 / speed
	# check if the unit should move
	last_move += Time.get_ticks_msec()
	if (last_move >= speed_target):
		last_move = 0.0
		return true
	return false
