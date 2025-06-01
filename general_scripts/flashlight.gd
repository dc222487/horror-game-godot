extends SpotLight3D

@onready var player = get_tree().current_scene.get_node("player/head")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform.origin = player.global_transform.origin

func _physics_process(delta: float) -> void:
	var rot_y = lerp_angle(global_rotation.y,player.global_rotation.y,0.2)
	var rot_x = lerp_angle(global_rotation.x,player.global_rotation.x,0.2)
	var rot_z = lerp_angle(global_rotation.z,player.global_rotation.z,0.2)
	global_rotation.y = rot_y
	global_rotation.x = rot_x
	global_rotation.z = rot_z
	
