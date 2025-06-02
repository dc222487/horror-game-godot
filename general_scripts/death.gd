extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("death")
	await get_tree().create_timer(5.5, true).timeout
	get_tree().quit()
