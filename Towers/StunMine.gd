class_name StunMine extends Tower

var stunMineScene = preload("res://Towers/StunMineScene.tscn")
var stunExplosion = preload("res://stun_explosion.tscn")
var instance: Node3D;

func _init() -> void:
	instance = stunMineScene.instantiate()
	self.add_child(instance)

	attack_range = 2
	attack_damage = 2 # Duration
	attack_speed = 1000

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

	Map.add_stun(global_position, attack_range, attack_damage)
	
	var expl = stunExplosion.instantiate()
	add_child(expl)

	return null
