class_name LaserProjectile extends Projectile

var rocketProjectile = preload("res://Projectiles/LaserProjectile.tscn")

var scene: Node3D

func _init(_map: Map) -> void:
	super(_map)
	scene = rocketProjectile.instantiate() as Node3D
	self.add_child(scene)
