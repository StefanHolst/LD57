class_name Soldier extends Unit

var soldierScene = preload("res://Units/SoldierScene.tscn")

var scene: Node3D

func _ready():
	var player = scene.find_child("AnimationPlayer") as AnimationPlayer
	player.play_section_with_markers("enemy_animations", "WalkStart", "WalkEnd")

func _init(_map: Map) -> void:
	super(_map)
	scene = soldierScene.instantiate() as Node3D
	self.add_child(scene)
	map = _map

	health = 100
	speed = 2

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100
