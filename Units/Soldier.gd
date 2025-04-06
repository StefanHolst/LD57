extends Unit

@onready var nav: NavigationAgent3D = $NavigationAgent3D;

@export var target: Vector3

enum Mode
{
	Walk,
	Attack,
	AttackBack
}

var body
var accel = 10
var mode: Mode = Mode.Walk;
var player: AnimationPlayer;

func _ready():
	body = find_child("Body")
	player = find_child("AnimationPlayer") as AnimationPlayer
	await get_tree().create_timer(randf()).timeout
	player.play_section_with_markers("enemy_animations", "WalkStart", "WalkEnd")
	
	nav.target_position = target
	nav.target_desired_distance = 4
	nav.target_reached.connect(attack)
	
	player.animation_finished.connect(attackDone)

func _init() -> void:
	max_health = 100
	health = max_health
	speed = 3

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100

func attack() -> void:
	if mode == Mode.Attack:
		return
	mode = Mode.Attack
	player.play_section_with_markers("attackAnim", "AttackStart", "AttackEnd")

func attackDone(anim: String) -> void:
	if mode == Mode.Attack:
		mode = Mode.AttackBack
		player.play_section_with_markers_backwards("attackAnim", "AttackStart", "AttackEnd")
	elif mode == Mode.AttackBack:
		Map.attack_hq(self)
		mode = Mode.Attack
		player.play_section_with_markers("attackAnim", "AttackStart", "AttackEnd")

func _physics_process(delta: float) -> void:
	if (target == null):
		return

	var direction = Vector3();
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	if direction.length() > 0.001:
		self.look_at(self.global_position + direction)
	
	velocity = velocity.lerp(direction * speed, accel * delta)

	move_and_slide()
