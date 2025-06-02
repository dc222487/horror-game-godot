extends Node3D

var opened = false
@export var locked = false

func ai_enable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open" and !opened:
		opened = true 
		$hinge/open.play()
		$AnimationPlayer.play("open")
		
func ai_disable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open" and opened:
		opened = false
		$hinge/close.play()
		$AnimationPlayer.play_backwards("open")
func toggle_door():
	if $AnimationPlayer.current_animation != "open" and !locked:
		opened = !opened
		if !opened:
			$hinge/close.play()
			$AnimationPlayer.play_backwards("open")
		
		if opened:
			$hinge/open.play()
			$AnimationPlayer.play("open")
