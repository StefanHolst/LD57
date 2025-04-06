extends Node

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")
var soldierScene = preload("res://Units/SoldierScene.tscn")
var tankScene = preload("res://Units/TankScene.tscn")
var explosion = preload("res://explosion.tscn")

var game: Node3D

var towers: Array = []
var units: Array = []
var projectiles: Array = []

func convertVector(v: Vector3) -> Vector3:
	var x2 = v.x * 2 + 1
	var y2 = v.y * 2 + 1
	var z2 = v.z * 2 + 1
	return Vector3(x2, y2, z2)

func add_to_scene():
	var target = Vector3(0,0,0)
	var spawn_point = convertVector(Vector3(-10, 1, 10))

	# Create test towers
	#var tower1 = LaserTower.new()
	#tower1.position = convertVector(Vector3(0, 1, 2))
	#towers.append(tower1)
	#game.add_child(tower1)
	#var tower2 = LaserTower.new()
	#tower2.position = convertVector(Vector3(-3, 1, 0))
	#towers.append(tower2)
	#game.add_child(tower2)

	## Create test units
	for i in range(0, 100):
		var unit = soldierScene.instantiate()
		unit.position = spawn_point
		unit.target = target
		units.append(unit)
		game.add_child(unit)
		await get_tree().create_timer(0.5).timeout
	for i in range(0, 1):
		var unit = tankScene.instantiate()
		unit.position = spawn_point
		unit.target = target
		units.append(unit)
		game.add_child(unit)

func add_projectile(p: Projectile):
	projectiles.append(p)
	game.add_child(p)
	Player.ShotsFired += 1

func remove_unit(unit: Unit) -> void:
	units.erase(unit)
	game.remove_child(unit)
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
				var exp = explosion.instantiate()
				exp.position = unit.position
				game.add_child(exp)
				remove_unit(unit)

func add_player_tower(position: Vector3):
	var tower = Player.NewTower.new()
	tower.position = Vector3(position.x, 3, position.z)
	towers.append(tower)
	game.add_child(tower)
