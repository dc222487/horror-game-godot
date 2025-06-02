extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(8.0, true).timeout
	get_tree().quit()
