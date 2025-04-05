class_name Map

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")

var map_floor: Array = []
var map_route: Array = []
var route: Array = []
var route_lookup = {}
var towers: Array = []
var units: Array = []

func _init() -> void:
	# Create route
	for x in range(0, 5):
		var scene = routeScene.instantiate() as Node3D
		scene.position = Vector3(x, 0, 3)
		map_route.append(scene)
		route.append(scene.position)
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
	for r in map_route:
		node.add_child(r)
	for t in towers:
		node.add_child(t)
	for u in units:
		node.add_child(u)

func move_units(_delta: float) -> void:
	if (route.size() == 0):
		return
	
	# Get the units that should move
	for unit : Unit in units:
		unit.move(_delta, route) # Move the unit along the route
