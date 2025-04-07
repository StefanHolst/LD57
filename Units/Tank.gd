extends Unit

var explosion = preload("res://explosion.tscn")

@onready var nav: NavigationAgent3D = $NavigationAgent3D;

@export var target: Vector3

var body
var accel = 10

func _ready():
	body = find_child("Body")
	
	nav.target_position = target
	nav.target_desired_distance = 4
	nav.target_reached.connect(attack)

func attack() -> void:
	print("Tank attacking")
	
	var expl = explosion.instantiate() as Node3D
	expl.position = global_position
	Map.add_child(expl)
	
	Map.attack_hq(self)
	
	Map.units.erase(self)
	call_deferred("queue_free")
	
func _init() -> void:
	max_health = 1000
	health = max_health
	speed = 10
	damage = 0.1

	upgrade_cost = 50
	upgrade_health = 20
	upgrade_speed = 1

	cost = 200
	sell_value = 100

func _physics_process(delta: float) -> void:
	if (target == null):
		return
	
	var direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	if direction.length() > 0.001:
		self.look_at(self.global_position + direction)
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
