class_name Soldier extends Unit

var soldierScene = preload("res://Units/SoldierScene.tscn")

var scene: Node3D

func _ready():
	var player = scene.find_child("AnimationPlayer") as AnimationPlayer
	var animation = player.get_animation("enemy_animations")
	var start = animation.get_marker_time("WalkStart")
	var end = animation.get_marker_time("WalkEnd")
	var duration = end - start;
	
	while true:
		player.play("enemy_animations")
		player.seek(start, true)
		await get_tree().create_timer(duration).timeout

		player.play_backwards("enemy_animations")
		player.seek(end, true)
		await get_tree().create_timer(duration).timeout
	player.stop()
	#player.play_section_with_markers("enemy_animations", "WalkStart", "WalkEnd")

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
