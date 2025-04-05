extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D;

@export var target2: Node3D;

var speed = 2
var accel = 10

func _physics_process(delta: float) -> void:
	var direction = Vector3();
	
	nav.target_position = target2.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	self.look_at(self.global_position + direction)
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
