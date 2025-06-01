extends RigidBody3D

@export var positions: Array[Node3D]
@onready var rng = RandomNumberGenerator.new()
@export var door: Node3D
var pos_obj 

func hit_obj(body):
	pos_obj = body 
	freeze = true 

func pickup_key():
	door.locked = false 
	queue_free()
func _physics_process(delta: float) -> void:
	if pos_obj != null: 
		global_transform.origin = pos_obj.global_transform.origin 

func _ready() -> void:
	var chance = rng.randi_range(0, positions.size() - 1)
	global_transform.origin = positions[chance].global_transform.origin
	print(chance)
	if name != "key":
		visible = false
	
	if chance > 12:
		disconnect("body_entered", Callable(self, "hit_obj"))
		freeze = true 
	
