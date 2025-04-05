class_name LaserProjectile extends Projectile

var projectile = preload("res://Projectiles/LaserProjectile.tscn")

var scene: Node3D
var direction: Vector3;
var start: Vector3;
var stop: Vector3;
var t: float = 0;

func _init(_map: Map, _position: Vector3, _target: Vector3) -> void:
	super(_map)
	scene = projectile.instantiate() as Node3D
	self.add_child(scene)
	self.look_at_from_position(_position, _target)

	speed = 6
	range = 1.5
	
	start = _position
	position = _position
	stop = _target
	direction = _target - _position

func _process(delta: float) -> void:
	t += delta * speed;
	position = start + direction * t;
	if t >= 1:
		map.add_damage(stop, self)
		self.call_deferred("queue_free")
