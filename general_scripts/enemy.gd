extends CharacterBody3D

@export var patrol_destinations: Array[Node3D]
@onready var player = get_tree().current_scene.get_node("player") 
var speed = 2.0
@onready var rng = RandomNumberGenerator.new()
var destination 
var chasing = false 
var destination_value 
var killed = false 
var chase_timer = 0.0
var idle = false
@export var footstep_sounds: Array[AudioStream]


func footsteps():
	if !chasing and $feet.pitch_scale != 1.0:
		$feet.pitch_scale = 1.0
	elif chasing and $feet.pitch_scale != 1.5:
		$feet.pitch_scale = 1.5
	if !$feet.playing:
		$feet.stream = footstep_sounds[rng.randi_range(0, footstep_sounds.size() - 1)]
		$feet.play()
		
func _ready() -> void:
	$monster_enemy/AnimationPlayer.play("idle") 
	pick_destination()

func stop_enemy():
	$monster_enemy/AnimationPlayer.play("idle") 
	idle = true
	speed = 0

func _process(delta: float) -> void:
	if !killed:
		if speed > 0:
			footsteps()
		if !chasing: 
			if $monster_enemy/AnimationPlayer.speed_scale != 1:
				$monster_enemy/AnimationPlayer.speed_scale = 1
			if speed != 2.0 and !idle:
				speed = 2.0
		if chasing:
			if $monster_enemy/AnimationPlayer.speed_scale != 2:
				$monster_enemy/AnimationPlayer.speed_scale = 2
			if speed != 5.0:
				speed = 5.0
			if chase_timer < 15.0:
				chase_timer += 1 * delta 
			else:
				chase_timer = 0
				if $killcast/killcast.enabled:
					$killcast/killcast.enabled = false
				chasing = false 
				pick_destination()
		if destination != null and !idle:
			var look_dir = lerp_angle(deg_to_rad(global_rotation_degrees.y), atan2(-velocity.x, -velocity.z), 0.5)
			global_rotation_degrees.y = rad_to_deg(look_dir)
			update_target_location()

func kill_player():
	if !$killcast/killcast.enabled:
		$killcast/killcast.enabled = true 
	$killcast.look_at(player.global_transform.origin)
	if $killcast/killcast.is_colliding():
		var hit = $killcast/killcast.get_collider()
		if hit.name == "player" and !killed:
			killed = true 
			$jumpscare_cam.current = true 
			$monster_enemy/AnimationPlayer.play("jumpscare")
			$monster_enemy/AnimationPlayer.speed_scale = 2 
			player.process_mode = Node.PROCESS_MODE_DISABLED
			await get_tree().create_timer(2.0, false).timeout 
			get_tree().change_scene_to_file("res://scenery/death.tscn")

func chase_player(chasecast: RayCast3D):
	if chasecast.is_colliding():
		var hit = chasecast.get_collider()
		if hit.name == "player":
			if !chasing:
				$monster_enemy/AnimationPlayer.play("walk") 
				chasing = true 
				destination = player


func _physics_process(_delta: float) -> void:
	if !killed:
		if chasing:
			kill_player()
		chase_player($chasecast)
		chase_player($chasecast2)
		chase_player($chasecast3)
		chase_player($chasecast4)
		chase_player($chasecast5)
		if destination != null:
			var current_location =  global_transform.origin 
			var next_location = $NavigationAgent3D.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * speed
			$NavigationAgent3D.set_velocity(new_velocity)
		
		
func pick_destination(dont_choose = null):
	if !chasing and !killed:
		$monster_enemy/AnimationPlayer.play("walk") 
		speed = 2.0
		idle = false 
		var num = rng.randi_range(0, patrol_destinations.size() - 1)
		destination_value = num
		destination = patrol_destinations[num]
		print(destination_value)
		if destination != null and dont_choose != null and destination == patrol_destinations[dont_choose]:
			if dont_choose < 1:
				destination = patrol_destinations[dont_choose + 1]
			if dont_choose > 0 and dont_choose <= patrol_destinations.size() - 1:
				destination = patrol_destinations[dont_choose - 1]

func update_target_location():
	$NavigationAgent3D.target_position = destination.global_transform.origin

func compute_velocity(safe_velocity: Vector3) -> void:
	if !killed:
		velocity = velocity.move_toward(safe_velocity, 0.25)
		move_and_slide()
