extends Camera3D

@export var mouse_sensitivity: float = 0.1  # Degrees per pixel
@export var move_speed: float = 5.0
@export var fast_multiplier: float = 3.0

var rotation_x := 0.0  # pitch
var rotation_y := 0.0  # yaw

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -89.9, 89.9)  # Prevent flipping
		rotation_degrees = Vector3(rotation_x, rotation_y, 0)

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	var direction := Vector3.ZERO

	#if Input.is_action_pressed("move_forward"):
		#direction -= transform.basis.z
	#if Input.is_action_pressed("move_backward"):
		#direction += transform.basis.z
	#if Input.is_action_pressed("move_left"):
		#direction -= transform.basis.x
	#if Input.is_action_pressed("move_right"):
		#direction += transform.basis.x
	#if Input.is_action_pressed("move_up"):
		#direction += transform.basis.y
	#if Input.is_action_pressed("move_down"):
		#direction -= transform.basis.y

	var speed := move_speed
	#if Input.is_action_pressed("move_fast"):
		#speed *= fast_multiplier

	if direction != Vector3.ZERO:
		translate(direction.normalized() * speed * delta)
