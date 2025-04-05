extends Unit

@onready var player: AnimationPlayer = $AnimationPlayer;

func _ready():
	var animation = player.get_animation("enemy_animations")
	var start = animation.get_marker_time("WalkStart")
	var end = animation.get_marker_time("WalkEnd")
	var duration = end - start;
	
	while true:
		var tree = get_tree()
		if (tree == null):
			break
		player.play("enemy_animations")
		player.seek(start, true)
		await get_tree().create_timer(duration).timeout
	player.stop()

func _init() -> void:
	health = 100
	speed = 2

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100
