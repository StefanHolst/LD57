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

func _init(start_pos: Vector3, rot: Quaternion, targetUnit: Node3D, minDistance: float = 2) -> void:
	position = start_pos
	rotation = rot.get_euler()
	trackTarget = targetUnit
	self.target = targetUnit.global_position
	
	state = State.Launch;
	stateTimeLeft = 0.5;
	
	speed = 20
	damage = 1000
	range = 5
	
	MinDistance = minDistance**2

func _ready() -> void:
	var mesh = projectile.instantiate() as Node3D
	mesh.scale = Vector3(0.4, 0.4, 0.4)
	mesh.rotation = Vector3(deg_to_rad(-90), 0,0)
	add_child(mesh)

func checkTrack() -> void:
	if trackTarget == null:
		pass
	elif not trackTarget.is_inside_tree():
		trackTarget = null
	else:
		self.target = trackTarget.global_position

func get_target() -> Vector3:
	if trackTarget == null:
		return self.target
	else:
		return self.target

func _process(_delta: float) -> void:
	checkTrack()
	
	if state == State.Launch:
		stateTimeLeft -= _delta
		if stateTimeLeft <= 0:
			state = State.Cruise
			print("Launched")
	elif state == State.Cruise:
		var hp = get_target()
		hp.y = global_position.y
		var dir_target = hp - global_position
		var dist = dir_target.length_squared()
		var dir_rocket = transform.basis.slerp(Basis.looking_at(dir_target), _delta*speed*INERTIA)
		rotation = dir_rocket.get_euler()
		
		if dist < track_distance:
			state = State.Track
			print("Track")
	elif state == State.Track:
		var targetPos = get_target()
		var dir_target = targetPos - global_position
		var dist = dir_target.length_squared()
		var dir_rocket = transform.basis.slerp(Basis.looking_at(dir_target), _delta*speed*INERTIA)
		rotation = dir_rocket.get_euler()
	
		if dist < MinDistance:
			print("Hit target")
			Map.add_damage(targetPos, self)
			
			var expl = explosion.instantiate() as Node3D
			expl.position = targetPos
			Map.add_child(expl)

			self.call_deferred("queue_free")
	
	position -= basis.z * _delta * speed
