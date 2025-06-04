extends Node3D

@onready var ui = get_tree().current_scene.get_node("player/player_ui")
var interacted = false 
func interact():
	if !interacted: 
		interacted = true
		visible = false
		$pickup.play()
		ui.set_task("Escape the house")
		get_tree().current_scene.get_node("scene_change_trigger/CollisionShape3D").disabled = false
		await get_tree().create_timer(0.52, false).timeout
		queue_free()
