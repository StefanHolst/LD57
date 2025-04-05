class_name RocketTower extends Tower

func _init() -> void:
	# Initialize the tower with specific properties
	attack_range = 200
	attack_damage = 50
	attack_speed = 1.0

	upgrade_cost = 100
	upgrade_range = 50
	upgrade_damage = 25
	upgrade_attack_speed = 0.5

	cost = 300
	sell_value = 150

	position = Vector2(0, 0)