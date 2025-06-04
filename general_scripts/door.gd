extends Node3D

var opened = false
@export var locked = false

func ai_enable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open" and !opened:
		opened = true
		if has_node("open"):
			$open.play()
		if has_node("hinge/open"):
			$hinge/open.play()
		$AnimationPlayer.play("open")
		
func ai_disable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open" and opened:
		opened = false
		if has_node("close"):
			$close.play()
		if has_node("hinge/close"):
			$hinge/close.play()
		$AnimationPlayer.play_backwards("open")
func toggle_door():
	if $AnimationPlayer.current_animation != "open" and !locked:
		opened = !opened
		if !opened:
			if has_node("close"):
				$close.play()
			if has_node("hinge/close"):
				$hinge/close.play()
			$AnimationPlayer.play_backwards("open")
		
		if opened:
			if has_node("open"):
				$open.play()
			if has_node("hinge/open"):
				$hinge/open.play()
			$AnimationPlayer.play("open")
