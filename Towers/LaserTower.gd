class_name LaserTower extends Tower

@export var Target: Node3D = Node3D.new();

var laserSound = preload("res://Sounds/Laser_Shoot10.wav")

var laserTowerModel = preload("res://Assets/lasertowerv1.glb")
var player: AudioStreamPlayer3D;
var instance: Node3D;
var turret: Node3D;
var barrel: Node3D;

func _init(_map: Map) -> void:
	super(_map)
	instance = laserTowerModel.instantiate()
	self.add_child(instance)
	
	player = AudioStreamPlayer3D.new();
	add_child(player);
	
	turret = instance.find_child("Turret")
	barrel = instance.find_child("Barrel")
	
	attack_range = 5.5
	attack_damage = 20
	attack_speed = 100

	upgrade_cost = 100
	upgrade_range = 50
	upgrade_damage = 25
	upgrade_attack_speed = 0.5

	cost = 300
	sell_value = 150

func _process(_delta: float) -> void:
	barrel.look_at(Target.position)
	turret.look_at(Vector3(Target.position.x, turret.global_position.y, Target.position.z))

var last_fire: float
func attack(unit: Unit) -> Node3D:
	Target = unit

	# determine if the tower is ready to attack
	if (last_fire + attack_speed > Time.get_ticks_msec()):
		return null
	last_fire = Time.get_ticks_msec()
	
	player.stream = laserSound;
	player.volume_db = -9;
	player.pitch_scale = randf_range(0.9, 1.1)
	player.play()

	# create projectile
	var p = LaserProjectile.new(map, barrel.global_position, unit.position)
	p.damage = attack_damage
	map.add_projectile(p)
	return null
