class_name Soldier extends Unit

var soldierScene = preload("res://Units/SoldierScene.tscn")

func _init() -> void:
	self.add_child(soldierScene.instantiate() as Node3D)

	health = 100
	speed = 0.1

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100
