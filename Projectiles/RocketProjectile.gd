class_name Rocket extends Projectile

var projectile = preload("res://Assets/rocket.glb")
var explosion = preload("res://explosion_big.tscn")

const INERTIA: float = 0.5
const track_distance: float = 10

var MinDistance: float;
var trackTarget: Node3D;

enum State
{
	Launch,
	Cruise,
	Track
}

var state: State = State.Launch;
var stateTimeLeft: float = 0;

func _init(start_pos: Vector3, rot: Quaternion, target: Node3D, minDistance: float = 0.5) -> void:
	position = start_pos
	rotation = rot.get_euler()
	trackTarget = target
	self.target = target.position
	
	state = State.Launch;
	stateTimeLeft = 0.5;
	
	speed = 5
	damage = 1000
	range = 5
	
	MinDistance = minDistance**2

func _ready() -> void:
	var mesh = projectile.instantiate() as Node3D
	mesh.scale = Vector3(0.4, 0.4, 0.4)
	mesh.rotation = Vector3(deg_to_rad(-90), 0,0)
	add_child(mesh)

func _process(_delta: float) -> void:
	if state == State.Launch:
		stateTimeLeft -= _delta
		if stateTimeLeft <= 0:
			state = State.Cruise
			print("Launched")
	elif state == State.Cruise:
		var hp = trackTarget.global_position
		hp.y = global_position.y
		var dir_target = hp - global_position
		var dist = dir_target.length_squared()
		var dir_rocket = transform.basis.slerp(basis.looking_at(dir_target), _delta*speed*INERTIA)
		rotation = dir_rocket.get_euler()
		
		if dist < track_distance:
			state = State.Track
			print("Track")
	elif state == State.Track:
		var targetPos = trackTarget.global_position
		var dir_target = targetPos - global_position
		var dist = dir_target.length_squared()
		var dir_rocket = transform.basis.slerp(basis.looking_at(dir_target), _delta*speed*INERTIA)
		rotation = dir_rocket.get_euler()
	
		if dist < MinDistance:
			print("Hit target")
			Map.add_damage(targetPos, self)
			
			var exp = explosion.instantiate() as Node3D
			exp.position = targetPos
			Map.add_child(exp)

			self.call_deferred("queue_free")
	
	position -= basis.z * _delta * speed
