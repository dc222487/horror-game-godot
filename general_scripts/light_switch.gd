extends Node3D


@export var on = false
@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D
@export var light_bulb: Node3D

func _ready() -> void:
	if !on:
		light_bulb.get_node("light").material_override = off_mat
		light_bulb.get_node("light2").material_override = off_mat
	if on:
		light_bulb.get_node("light").material_override = on_mat
		light_bulb.get_node("light2").material_override = on_mat
		
	light_bulb.get_node("OmniLight3D").visible = on 
		
func toggle_light():
	on = !on
	if on:
		$sound.pitch_scale = 1.0 
		$on.visible = true 
		$off.visible = false
		light_bulb.get_node("light").material_override = on_mat
		light_bulb.get_node("light2").material_override = on_mat
	elif !on:
		$sound.pitch_scale = 0.8
		$on.visible = false
		$off.visible = true
		light_bulb.get_node("light").material_override = off_mat
		light_bulb.get_node("light2").material_override = off_mat
	$sound.play()
	light_bulb.get_node("OmniLight3D").visible = on 
