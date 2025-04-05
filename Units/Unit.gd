class_name Unit extends Node3D

# Properties
var health: int
var speed: float # how many times the unit can move in a second

var upgrade_cost: int
var upgrade_health: int
var upgrade_speed: int

var cost: int
var sell_value: int

var current_route_index: int = 0

var map: Map

func _init(_map: Map) -> void:
	map = _map
	#connect("projectile_entered", Callable(self, "_on_area_entered"))  # Correct way to connect the signal

#func move(_delta: float, route: Array) -> void:
	#var target_route = route[current_route_index] as Vector3 # Get the target route
	#var direction = (target_route - global_position).normalized() # Calculate the direction towards the target route
	#var distance = global_position.distance_to(target_route) # Calculate the distance to the target route
#
	#if (distance > 0.1):
		#global_position += direction * speed * _delta
		#look_at(target_route, Vector3.UP)
	#else:
		#current_route_index += 1 # Move to next route
		#if (current_route_index >= route.size()):
			## Unit has reached the end of the route
			#current_route_index = 0 # Reset the route index
##			map.remove_unit(self)
#
#func projectile_entered(projectile) -> void:
	#if projectile.is_in_group("projectile"): # Check if the object is in the enemy group
		#projectile.queue_free() # Remove the projectile
		#map.remove_unit(self)
