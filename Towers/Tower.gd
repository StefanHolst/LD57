class_name Tower

# Properties
var attack_range = 0
var attack_damage = 0
var attack_speed = 0

var upgrade_cost = 0
var upgrade_range = 0
var upgrade_damage = 0
var upgrade_attack_speed = 0

var cost = 0
var sell_value = 0

var position = Vector2()

func unit_in_range(unit):
	# Check if the unit is within range
	return position.distance_to(unit.position) <= attack_range



# Map
#   List of Route points
#   List of Towers
#   List of Units

#   Move Units()
#   {
#      for each unit in units:
#         move unit to next point
#         check if unit reaches end of route
#            start attack on the main tower
# 		  check if any are in range of a tower
# 		  if so, attack unit
# 		     check if unit is dead, if so, remove it from the list
#	}