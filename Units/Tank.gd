extends Unit

@onready var nav: NavigationAgent3D = $NavigationAgent3D;

@export var target: Vector3

var body
var accel = 10

func _ready():
	healthBar = find_child("HealthBar")
	body = find_child("Body")

func _init() -> void:
	max_health = 1000
	health = max_health
	speed = 10

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100

func _physics_process(delta: float) -> void:
	if (target == null):
		return
	
	var direction = Vector3();
	nav.target_position = target
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	if direction.length() > 0.001:
		self.look_at(self.global_position + direction)
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
