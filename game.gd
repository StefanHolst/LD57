extends Node3D

@onready var camera = $Camera3D

var terrain: Node3D
var gridmap: GridMap
var highlight: Node3D

func _ready() -> void:
	add_child(Map.scene)
	gridmap = Map.scene.find_child("GridMap") as GridMap
	highlight = Map.scene.find_child("Highlight") as Node3D

	Map.game = self
	Player.IngameMenu = find_child("IngameMenu")
	Player.ready()

func _process(_delta: float) -> void:
	Map.towers_attack()
	
	# Place towers
	if (Player.HasPlacement):
		var hover = get_hovered_grid_position()
		if hover != null:
			highlight.visible = true
			highlight.position = hover
		else:
			highlight.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and Player.HasPlacement and highlight.visible:
			if (Map.add_player_tower(highlight.position)):
				Player.HasPlacement = false
				highlight.visible = false

func get_hovered_grid_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000

	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 0xFFFFFFFF, []))

	if result and result.has("position"):
		var hit_position = result.position
		var cell = world_to_cell(hit_position)
		return cell

	return null

func world_to_cell(world_pos: Vector3) -> Vector3i:
	var local_pos = gridmap.to_local(world_pos)
	var cell_size = gridmap.cell_size
	return Vector3i(
		floor(local_pos.x / cell_size.x) * 2 + 1,
		floor(local_pos.y / cell_size.y) * 2 + 1,
		floor(local_pos.z / cell_size.z) * 2 + 1
	)
