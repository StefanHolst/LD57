extends Camera3D

@export var target: Vector3 = Vector3.ZERO
@export var distance := 30.0
@export var min_distance := 12.0
@export var max_distance := 150.0
@export var zoom_speed := 1.0
@export var rotate_speed := 0.01
@export var vertical_angle_limit := Vector2(0.4, 1.2) # radians (~-70 to +70 degrees)

var horizontal_angle := 0.0
var vertical_angle := 0.6
var rotating := false

func _input(event):
	# Start or stop rotation
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			rotating = event.pressed
	# Rotation
	if event is InputEventMouseMotion and rotating:
		horizontal_angle -= event.relative.x * rotate_speed
		var verticalMin = vertical_angle_limit.x
		var verticalMax = vertical_angle_limit.y
		vertical_angle = clamp(vertical_angle - event.relative.y * rotate_speed, verticalMin, verticalMax)
	# Zoom on scroll
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		distance = max(min_distance, distance - zoom_speed)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		distance = min(max_distance, distance + zoom_speed)
	elif event is InputEventPanGesture:
		# Negative y is zoom in, positive y is zoom out
		distance = clamp(distance + event.delta.y * 0.05, min_distance, max_distance)

func _process(delta):
	# Calculate spherical offset from angles and distance
	var offset = Vector3(
		distance * cos(vertical_angle) * sin(horizontal_angle),
		distance * sin(vertical_angle),
		distance * cos(vertical_angle) * cos(horizontal_angle)
	)

	global_position = target + offset
	look_at(target, Vector3.UP)
