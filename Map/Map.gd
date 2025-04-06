extends Node3D

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")
var soldierScene = preload("res://Units/SoldierScene.tscn")
var tankScene = preload("res://Units/TankScene.tscn")
var explosion = preload("res://explosion.tscn")
var mapScene = preload("res://Map/MapScene.tscn")

var game: Node3D
var scene: Node3D

var HQ: Headquarter;

var towers: Array = []
var units: Array = []
var projectiles: Array = []

var newUnits: Array = []
var target = Vector3(0,0,0)
var spawn_points: Array[Vector3] = []
var spawn_interval = 0.2 # seconds

func _init() -> void:
	scene = mapScene.instantiate()
	var spawn1 = scene.find_child("SpawnPoint1") as Node3D
	var spawn2 = scene.find_child("SpawnPoint2") as Node3D
	spawn_points.append(spawn1.position)
	spawn_points.append(spawn2.position)
	
	## Create test units
	for i in range(0, 1000):
		var unit = soldierScene.instantiate()
		unit.position = spawn_points[randi() % 2]
		unit.position.x += (randf() * 4 - 2)
		unit.position.z += (randf() * 4 - 2)
		unit.target = target
		newUnits.insert(randi() % (newUnits.size() + 1), unit)
	for i in range(0, 1000):
		var unit = tankScene.instantiate()
		unit.position = spawn_points[randi() % 2]
		unit.position.x += (randf() * 4 - 2)
		unit.position.z += (randf() * 4 - 2)
		unit.target = target
		newUnits.insert(randi() % (newUnits.size() + 1), unit)

var last_unit_add: float = 0
func _process(delta: float) -> void:
	last_unit_add -= delta
	if (last_unit_add < 0):# and units.size() < 300):
		last_unit_add = spawn_interval
		var unit = newUnits.pop_front()
		if unit != null:
			units.append(unit)
			add_child(unit)

func convertVector(v: Vector3) -> Vector3:
	var x2 = v.x * 2 + 1
	var y2 = v.y * 2 + 1
	var z2 = v.z * 2 + 1
	return Vector3(x2, y2, z2)

func add_projectile(p: Projectile):
	projectiles.append(p)
	game.add_child(p)
	Player.ShotsFired += 1

func remove_unit(unit: Unit) -> void:
	units.erase(unit)
	remove_child(unit)
	unit.queue_free()
	Player.UnitsKilled += 1
	Player.Money += unit.sell_value

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
				var expl = explosion.instantiate()
				expl.position = unit.position
				game.add_child(expl)
				remove_unit(unit)

func add_new_item(selectedPosition: Vector3) -> bool:
	# determine height level the new defence is
	var place_height = Player.NewItem["height"]
	
	# Check if block is allowed to be placed here
	if (place_height != selectedPosition.y - 1): # Don't mind it...
		print(selectedPosition.y)
		return false
	
	# check if a tower already exist
	for tower in towers:
		if tower.position.x == selectedPosition.x and tower.position.z == selectedPosition.z:
			return false
	
	var tower = Player.NewItem["type"].new()
	tower.position = Vector3(selectedPosition.x, place_height, selectedPosition.z)
	towers.append(tower)
	game.add_child(tower)
	
	return true
	
func attack_hq(attacker: Unit) -> void:
	print("Attacked HQ")
	HQ.HP -= 0.01
