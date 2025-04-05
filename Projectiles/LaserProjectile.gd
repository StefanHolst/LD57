class_name LaserProjectile extends Projectile

var projectile = preload("res://Projectiles/LaserProjectile.tscn")

var scene: Node3D
var direction: Vector3;
var start: Vector3;
var stop: Vector3;
var t: float = 0;

const SPEED = 6;

func _init(_map: Map, position: Vector3, target: Vector3) -> void:
	super(_map)
	scene = projectile.instantiate() as Node3D
	self.add_child(scene)
	self.look_at_from_position(position, target)

	self.start = position
	self.position = position
	self.stop = target
	direction = target - position

func _process(delta: float) -> void:
	t += delta * SPEED;
	position = start + direction * t;
	if t >= 1:
		map.add_damage(self.target, self)
		self.call_deferred("queue_free")
