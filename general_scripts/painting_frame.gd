extends Node3D

@export var painting: StandardMaterial3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Plane.material_override = painting
