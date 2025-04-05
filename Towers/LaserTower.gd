class_name LaserTower extends Tower

@export var Target: Node3D = Node3D.new();

var laserTowerModel = preload("res://Assets/lasertowerv1.glb")
var instance: Node3D;
var turret: Node3D;
var barrel: Node3D;

func _init() -> void:
	instance = laserTowerModel.instantiate()
	self.add_child(instance)
	
	turret = instance.find_child("Turret")
	barrel = instance.find_child("Barrel")
	
	attack_range = 200
	attack_damage = 50
	attack_speed = 1.0

	upgrade_cost = 100
	upgrade_range = 50
	upgrade_damage = 25
	upgrade_attack_speed = 0.5

	cost = 300
	sell_value = 150

func _process(_delta: float) -> void:
	barrel.look_at(Target.position)
	turret.look_at(Vector3(Target.position.x, turret.position.y, Target.position.z))
