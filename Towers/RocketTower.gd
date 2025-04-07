class_name RocketTower extends Tower

var rockerTowerModel = preload("res://Towers/RocketTowerScene.tscn")
var instance: Node3D;

func _init() -> void:
	instance = rockerTowerModel.instantiate()
	self.add_child(instance)

	attack_range = 200
	attack_damage = 50
	attack_speed = 3000

	upgrade_cost = 100
	upgrade_range = 50
	upgrade_damage = 25
	upgrade_attack_speed = 0.5

	cost = 300
	sell_value = 150

var last_fire: float
func attack(unit: Unit) -> Node3D:
	# determine if the tower is ready to attack
	if (last_fire + attack_speed > Time.get_ticks_msec()):
		return null
	last_fire = Time.get_ticks_msec()
	
	var player = instance.find_child("AnimationPlayer") as AnimationPlayer
	var player2 = instance.find_child("AnimationPlayer2") as AnimationPlayer
	player.play("lid1Action_001")
	player2.play("lid2Action_001")
	
	var p = Rocket.new(global_position, Quaternion.from_euler(Vector3(PI/2,0,0)), unit)
	p.damage = attack_damage
	await get_tree().create_timer(0.7).timeout

	Map.add_projectile(p)
	
	player.play_backwards("lid1Action_001")
	player2.play_backwards("lid2Action_001")
	await get_tree().create_timer(0.7).timeout
	
	return null
