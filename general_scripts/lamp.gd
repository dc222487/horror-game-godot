extends Node3D

@export var on = false 
@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D
@export var light_colour: Color

func _ready() -> void:
	$OmniLight3D.light_color = light_colour
	
	if on:
		$lamp_head.material_override = on_mat
	
	if !on:
		$lamp_head.material_override = off_mat
	$OmniLight3D.visible = on 

func toggle_light():
	on = !on 
	if on:
		$sound.pitch_scale = 1.0
		$lamp_head.material_override = on_mat
	
	if !on:
		$sound.pitch_scale = 0.8
		$lamp_head.material_override = off_mat
	$sound.play()
	$OmniLight3D.visible = on 
