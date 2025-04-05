class_name Map

var route_points: Array = []
var towers: Array = []
var units: Array = []

func _init() -> void:
	# Create test towers
	for i in range(0, 3):
		var tower1 = RocketTower.new()
		tower1.position = Vector3(i * 2, 0, 0)
		towers.append(tower1)


#	# Create test units
#	var unit1 = Soldier.new(Vector2(1, 1))
#	units.append(unit1)
	
	# Create test route points
#	route_points.append(Vector2(1, 1))
#	route_points.append(Vector2(2, 1))
#	route_points.append(Vector2(3, 1))
	

func move_units():
	pass
#   {
#      for each unit in units:
#         move unit to next point
#         check if unit reaches end of route
#            start attack on the main tower
# 		  check if any are in range of a tower
# 		  if so, attack unit
# 		     check if unit is dead, if so, remove it from the list
#	}
