extends Node3D

var floorScene = preload("res://Map/FloorScene.tscn")
var routeScene = preload("res://Map/RouteScene.tscn")
var soldierScene = preload("res://Units/SoldierScene.tscn")
var tankScene = preload("res://Units/TankScene.tscn")
var explosion = preload("res://explosion.tscn")
var mapScene = preload("res://Map/MapScene.tscn")

var game: Node3D
var endgameScreen: Control;
var scene: Node3D

var HQ: Headquarter;

var towers: Array[Tower] = []
var units: Array[Unit] = []
var projectiles: Array[Projectile] = []

var newUnits: Array = []
var target = Vector3(0,0,0)
var spawn_points: Array[Vector3] = []
var spawn_interval = 0.2 # seconds
var wave_interval = 20 # seconds
var last_unit_add: float = 0

var is_ready = false
var hasEnded = false

var waves = [
	{# 110
		"Soldiers": 100,
		"Tanks": 10
	},
	{# 230
		"Soldiers": 100,
		"Tanks": 20
	},
	{# 400
		"Soldiers": 150,
		"Tanks": 20
	},
	{# 720
		"Soldiers": 300,
		"Tanks": 20
	},
	{# 1070
		"Soldiers": 300,
		"Tanks": 50
	},
	{# 2000
		"Soldiers": 600,
		"Tanks": 40
	}
]


func setup():
	spawn_interval = 0.2
	last_unit_add = 0
	hasEnded = false
	scene = mapScene.instantiate()
	newUnits = []
	
	for tower in towers:
		if tower != null:
			remove_child(tower)
			tower.queue_free()
	towers = []
	
	for unit in units:
		remove_child(unit)
		unit.queue_free()
	units = []
	
	for p in projectiles:
		if p != null:
			remove_child(p)
			p.queue_free()
	projectiles = []
	
	var spawn1 = scene.find_child("SpawnPoint1") as Node3D
	var spawn2 = scene.find_child("SpawnPoint2") as Node3D
	spawn_points.append(spawn1.position)
	spawn_points.append(spawn2.position)
	
	is_ready = true

func prepare_wave():
	if is_ready == false:
		return
	var wave = waves[Player.Wave]
	
	for i in range(0, wave["Soldiers"]):
		var unit = soldierScene.instantiate()
		unit.position = spawn_points[randi() % 2]
		unit.position.x += (randf() * 4 - 2)
		unit.position.z += (randf() * 4 - 2)
		unit.target = target
		newUnits.insert(randi() % (newUnits.size() + 1), unit)
	for i in range(0, wave["Tanks"]):
		var unit = tankScene.instantiate()
		unit.position = spawn_points[randi() % 2]
		unit.position.x += (randf() * 4 - 2)
		unit.position.z += (randf() * 4 - 2)
		unit.target = target
		newUnits.insert(randi() % (newUnits.size() + 1), unit)
	Player.Wave += 1

func _process(delta: float) -> void:
	last_unit_add -= delta
	if (last_unit_add < 0):# and units.size() < 300):
		last_unit_add = spawn_interval
		var unit = newUnits.pop_front()
		if unit != null:
			units.append(unit)
			add_child(unit)
		else: #next wave
			if Player.Wave + 1 >= waves.size():
				game_over()
			else:
				prepare_wave()
				last_unit_add = wave_interval

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
			var distance = tower.position.distance_squared_to(unit.position)
			if (closest_unit == null or distance < closest_distance):
				closest_unit = unit
				closest_distance = distance

		if (closest_unit != null and closest_distance < (tower.attack_range**2)):
			tower.attack(closest_unit) # Attack the closest unit
			pass

func add_damage(position: Vector3, projectile: Projectile) -> void:
	# Find the unit at the position
	var rangeSqr = projectile.range ** 2
	for unit in units:
		if (unit.position.distance_squared_to(position) < rangeSqr):
			unit.health -= projectile.damage
			var healthPercent = (unit.health / unit.max_health) * 100.0
			unit.healthBar.value = healthPercent
			unit.healthBar.visible = true
			if (unit.health <= 0):
				var expl = explosion.instantiate()
				expl.position = unit.position
				game.add_child(expl)
				remove_unit(unit)

func add_stun(position: Vector3, radius: float, duration: float) -> void:
	var rangeSqr = radius ** 2
	for unit in units:
		if (unit.position.distance_squared_to(position) < rangeSqr):
			unit.stun(duration)
	print("Stun")

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
	if !hasEnded:
		HQ.HP -= attacker.damage
		if HQ.HP < 0:
			game_over()
	elif HQ != null:
		print("Attacked HQ: ", HQ.HP)

func game_over():
	is_ready = false
	hasEnded = true
	spawn_interval = 1000
	for t in towers:
		(t as Tower).attack_speed = 1000000
	
	endgameScreen.time = 10
	endgameScreen.credits = Player.Money
	endgameScreen.visible = true
