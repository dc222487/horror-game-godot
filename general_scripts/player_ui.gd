extends Control

@onready var safe_anim = get_tree().current_scene.get_node("house/safe/AnimationPlayer")
@onready var rng = RandomNumberGenerator.new()
@onready var code_paper = get_tree().current_scene.get_node("code_paper")
var safe_password

var safe_interactable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$fade_ui/AnimationPlayer.play("fade")
	$safe_ui.visible = false 
	$pause_menu.visible = false 
	set_task("Ring the door bell")
	var p1 = rng.randi_range(0,9)
	var p2 = rng.randi_range(0,9)
	var p3 = rng.randi_range(0,9)
	var p4 = rng.randi_range(0,9)
	safe_password = str(p1) + str(p2) + str(p3) + str(p4)
	code_paper.get_node("code_text").mesh.text = safe_password
	print(safe_password)
	await get_tree().create_timer(1.1, false).timeout
	$fade_ui.visible = false

func play_hover():
	$hover.pitch_scale = rng.randf_range(0.75, 1.25)
	$hover.play()

func resume_game():
	$interact.play()
	get_tree().paused = false 
	$pause_menu.visible = false 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func quit_game():
	$interact.play()
	await get_tree().create_timer(0.5, true).timeout
	get_tree().quit()

func open_safe_password():
	if safe_interactable:
		$safe_ui.visible = true 
		get_tree().paused = true 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func confirm_password():
	$interact.play()
	if $safe_ui/password.text == safe_password:
		safe_anim.play("open")
		safe_interactable = false 
		exit_safe()
func exit_safe():
	$interact.play()
	$safe_ui.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func set_task(task_text: String):
	$task_sound.play()
	$task_ui/task_text.text = task_text
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$safe_ui.visible:
		$pause_menu.visible = !$pause_menu.visible 
		get_tree().paused = $pause_menu.visible
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
