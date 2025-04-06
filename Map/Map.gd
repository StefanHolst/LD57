extends Node3D

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")
var soldierScene = preload("res://Units/SoldierScene.tscn")
var tankScene = preload("res://Units/TankScene.tscn")
var explosion = preload("res://explosion.tscn")
var mapScene = preload("res://Map/MapScene.tscn")

var game: Node3D
var scene: Node3D

var HQ: Node3D;

var towers: Array = []
var units: Array = []
var projectiles: Array = []

var newUnits: Array = []
var target = Vector3(0,0,0)
var spawn_point = convertVector(Vector3(-10, 1, 10))
var spawn_interval = 0.2 # seconds

func _init() -> void:
	scene = mapScene.instantiate()
	
	## Create test units
	for i in range(0, 1000):
		var unit = soldierScene.instantiate()
		unit.position = spawn_point
		unit.target = target
		newUnits.insert(randi() % (newUnits.size() + 1), unit)
	for i in range(0, 1000):
		var unit = tankScene.instantiate()
		unit.position = spawn_point
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

func add_player_tower(position: Vector3) -> bool:
	# check if a tower already exist
	for tower in towers:
		if tower.position.x == position.x and tower.position.z == position.z:
			return false
		#if position.is_equal_approx(tower.position):
			#return false
	
	var tower = Player.NewTower.new()
	tower.position = Vector3(position.x, 3, position.z)
	towers.append(tower)
	game.add_child(tower)
	
	return true
