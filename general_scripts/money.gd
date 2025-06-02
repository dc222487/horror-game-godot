extends Node3D

@onready var ui = get_tree().current_scene.get_node("player/player_ui")

func interact():
	ui.set_task("Escape the house")
	get_tree().current_scene.get_node("scene_change_trigger/CollisionShape3D").disabled = false
	queue_free()
