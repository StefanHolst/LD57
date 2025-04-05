class_name RocketTower extends Tower

var rocketTowerScene = preload("res://Towers/RocketTowerScene.tscn")

func _init() -> void:
	self.add_child(rocketTowerScene.instantiate() as Node3D)

	attack_range = 200
	attack_damage = 50
	attack_speed = 1.0

	upgrade_cost = 100
	upgrade_range = 50
	upgrade_damage = 25
	upgrade_attack_speed = 0.5

	cost = 300
	sell_value = 150
