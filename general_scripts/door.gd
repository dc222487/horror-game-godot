extends Node3D

var opened = false
@export var locked = false

func ai_enable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open" and !opened:
		opened = true 
		$AnimationPlayer.play("open")
func ai_disable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open" and opened:
		opened = false
		$AnimationPlayer.play_backwards("open")
func toggle_door():
	if $AnimationPlayer.current_animation != "open" and !locked:
		opened = !opened
		if !opened:
			$AnimationPlayer.play_backwards("open")
		
		if opened:
			$AnimationPlayer.play("open")
