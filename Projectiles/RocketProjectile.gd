class_name Rocket extends Projectile

var projectile = preload("res://Assets/rocket.glb")

@export var Target: Node3D;
@export var evt: Callable;

const INERTIA: float = 0.1

var MinDistance: float;

func _init(start_pos: Vector3, rot: Quaternion, target: Node3D, minDistance: float = 0.1) -> void:
	position = start_pos
	rotation = rot.get_euler()
	
	Target = target
	MinDistance = minDistance**2

func _process(_delta: float) -> void:
	var dist = position.distance_squared_to(Target.position)
	if dist < MinDistance:
		evt.call(Target, self)
		self.call_deferred("queue_free")
	else:
		var dir_target = Target.position - position
		var dir_rocket = transform.basis.slerp(basis.looking_at(dir_target), _delta*INERTIA)
		
		
		
		
		
