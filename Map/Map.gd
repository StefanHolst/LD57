class_name Map

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")

var map_floor: Array = []
var route: Array     = []
var route_lookup = {}
var towers: Array = []
var units: Array = []

func _init() -> void:
	# Create route
	for x in range(0, 5):
		var scene = routeScene.instantiate() as Node3D
		scene.position = Vector3(x, 0, 3)
		route.append(scene)
		route_lookup[scene.position] = scene

	# Generate floor
	for y in range(0, 5):
		for x in range(0, 5):
			var pos = Vector3(x, 0, y)
			if (route_lookup.has(pos) == false):
				var scene = floorScene.instantiate() as Node3D
				scene.position = pos
				map_floor.append(scene)

	# Create test towers
	for i in range(0, 3):
		var tower1 = RocketTower.new()
		tower1.position = Vector3(i * 2, 0, 0)
		towers.append(tower1)

	# Create test units
	for i in range(0, 3):
		var unit = Soldier.new()
		unit.position = Vector3(0, 0, 3)
		units.append(unit)

func add_to_scene(node: Node3D):
	for f in map_floor:
		node.add_child(f)
	for r in route:
		node.add_child(r)
	for t in towers:
		node.add_child(t)
	for u in units:
		node.add_child(u)

func move_units():
	for unit in units:
		if unit.should_move():
			move_unit(unit, Vector3(0.1, 0, 0))
			
func move_unit(unit: Unit, target: Vector3):
	# Move the unit towards the target
	unit.position = (target + unit.position)
	
	
#   {
#      for each unit in units:
#         move unit to next point
#         check if unit reaches end of route
#            start attack on the main tower
# 		  check if any are in range of a tower
# 		  if so, attack unit
# 		     check if unit is dead, if so, remove it from the list
#	}
