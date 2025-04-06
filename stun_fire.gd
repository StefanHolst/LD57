extends Node3D

@onready var stundebris: GPUParticles3D = $StunDebris
@onready var stunfire: GPUParticles3D = $stunFire
@onready var stunsmoke: GPUParticles3D = $stunSmoke
#@onready var explosion_sound: AudioStreamPlayer3D = $ExplosionSound


func _ready():
	stundebris.emitting = true
	stunsmoke.emitting = true
	stunfire.emitting = true
	#explosion_sound.pitch_scale = randf_range(2.0, 3.5)
	#explosion_sound.play()
	await get_tree().create_timer(2.0).timeout
	call_deferred("queue_free")
