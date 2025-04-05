class_name Map

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")

var game: Node3D

var map_floor: Array = []
var map_route: Array = []
var route: Array = []
var route_lookup = {}
var towers: Array = []
var units: Array = []
var projectiles: Array = []

func _init(_game: Node3D) -> void:
	game = _game
	
	

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
		var tower1 = LaserTower.new(self)
		tower1.position = Vector3(i * 2, 0, 0)
		towers.append(tower1)

	# Create test units
	for i in range(0, 3):
		var unit = Soldier.new(self)
		unit.position = Vector3(0, 0, 3)
		unit.speed = i + 1
		print(unit.speed)
		units.append(unit)

func add_to_scene():
	for f in map_floor:
		game.add_child(f)
	for r in map_route:
		game.add_child(r)
	for t in towers:
		game.add_child(t)
	for u in units:
		game.add_child(u)

func add_projectile(p: Projectile):
	projectiles.append(p)
	game.add_child(p)

func remove_unit(unit: Unit) -> void:
	units.erase(unit)
	game.remove_child(unit)

func move_units(_delta: float) -> void:
	if (route.size() == 0):
		return
	# Get the units that should move
	for unit in units:
		unit.move(_delta, route) # Move the unit along the route

func towers_attack() -> void:
	for tower in towers:
		# find the closest unit
		var closest_unit = null
		var closest_distance = 9999999.0
		for unit in units:
			var distance = tower.position.distance_to(unit.position)
			if (closest_unit == null or distance < closest_distance):
				closest_unit = unit
				closest_distance = distance

		if (closest_unit != null and closest_distance < tower.attack_range):
			tower.attack(closest_unit) # Attack the closest unit
			pass
