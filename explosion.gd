extends Node3D

@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var smoke: GPUParticles3D = $Smoke
@onready var explosion_sound: AudioStreamPlayer3D = $ExplosionSound


func _ready():
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	explosion_sound.pitch_scale = randf_range(2.0, 3.5)
	explosion_sound.play()
	await get_tree().create_timer(2.0).timeout
	call_deferred("queue_free")
