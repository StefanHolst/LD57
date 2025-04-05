class_name Soldier extends Unit

func _init() -> void:
	# Initialize the unit with specific properties
	health = 100
	speed = 5

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100

	position = Vector2(0, 0)
