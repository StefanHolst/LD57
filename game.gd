extends Node3D

var terrainScene = preload("res://Map/terrain1.tscn")

@onready var camera = $Camera3D

var terrain: Node3D

func _ready() -> void:
	terrain = terrainScene.instantiate() as Node3D
	add_child(terrain)
	
	Map.game = self
	Map.add_to_scene()
	Player.IngameMenu = find_child("IngameMenu")
	Player.ready()

func _process(_delta: float) -> void:
	Map.towers_attack()
	var hover = get_hovered_grid_position()
	#print(hover)

func get_hovered_grid_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000

	var space_state = get_world_3d().direct_space_state
	var t = PhysicsRayQueryParameters3D.create(from, to, 0xFFFFFFFF, [])
	t.collide_with_areas = true
	t.hit_from_inside = true
	var result = space_state.intersect_ray(t)
	print(result)

	if result and result.has("position"):
		print(result)
		#var hit_position = result.position
		#var cell = terrain.world_to_map(hit_position)
		#return cell

	return null
