extends Node

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")
var terrain1 = preload("res://Map/terrain1.tscn")
var soldierScene = preload("res://Units/SoldierScene.tscn")
var tankScene = preload("res://Units/TankScene.tscn")
var explosion = preload("res://explosion.tscn")

var game: Node3D

var map_floor: Array = []
var map_route: Array = []
var route: Array = []
var route_lookup = {}
var towers: Array = []
var units: Array = []
var projectiles: Array = []

func _init() -> void:
	var terrain = terrain1.instantiate()
	map_floor.append(terrain)
	
	var target = Vector3(0,0,0)

	# Create test towers
	var tower1 = LaserTower.new()
	tower1.position = Vector3(1, 3, 5)
	towers.append(tower1)
	var tower2 = LaserTower.new()
	tower2.position = Vector3(-5, 3, 3)
	towers.append(tower2)
#
	## Create test units
	for i in range(0, 10):
		var unit = soldierScene.instantiate()
		unit.position = Vector3(-1, 3, 10 + i)
		unit.target = target
		units.append(unit)
	for i in range(0, 10):
		var unit = tankScene.instantiate()
		unit.position = Vector3(-21, 5 + i, 26)
		unit.target = target
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
	Player.ShotsFired += 1

func remove_unit(unit: Unit) -> void:
	units.erase(unit)
	game.remove_child(unit)
	Player.UnitsKilled += 1

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

func add_damage(position: Vector3, projectile: Projectile) -> void:
	# Find the unit at the position
	for unit in units:
		if (unit.position.distance_to(position) < projectile.range):
			unit.health -= projectile.damage
			var healthPercent = (unit.health / unit.max_health) * 100.0
			unit.healthBar.value = healthPercent
			unit.healthBar.visible = true
			if (unit.health <= 0):
				var exp = explosion.instantiate()
				exp.position = unit.position
				game.add_child(exp)
				remove_unit(unit)
