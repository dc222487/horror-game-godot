extends CanvasLayer

var player_head
var environment: Environment

func _ready() -> void:
	if get_tree().current_scene.name == "level":
		player_head = get_tree().current_scene.get_node("player/head")
		environment = get_tree().current_scene.get_node("WorldEnvironment").environment
	set_button_setting("volumetrics", $volumetric_button)
	set_button_setting("glow", $glow_button)
	set_button_setting("ssil", $ssil_button)
	set_button_setting("vsync", $vsync_button)
	set_option_setting("fps", $fps_button)
	set_option_setting("window_mode", $window_mode)
	set_option_setting("aa", $aa_button) 
	set_option_setting("shadows", $shadow_button)
	set_slider_setting("3d_scaling", $scaling_slider)
	set_slider_setting("master_volume", $volume_slider)
	set_slider_setting("sfx_volume", $sfx_slider)
	set_slider_setting("music_volume", $music_slider)
	set_slider_setting("look_speed", $look_slider)
	set_volumetrics($volumetric_button.button_pressed)
	set_glow($glow_button.button_pressed)
	set_aa($aa_button.selected)
	set_master_volume($volume_slider.value)
	set_sfx_volume($sfx_slider.value)
	set_music_volume($music_slider.value) 
	set_look_speed($look_slider.value)
	set_shadows($shadow_button.selected)
	set_window_mode($window_mode.selected)
	set_fps_cap($fps_button.selected)
	set_vsync($vsync_button.button_pressed)
	set_ssil($ssil_button.button_pressed)
	scale_3d($scaling_slider.value)
	
	
func set_button_setting(save_name, button):
	var load = FileAccess.open("user://" + save_name + ".yeet", FileAccess.READ)
	if load:
		if load.get_as_text() == "false":
			button.button_pressed = false
		elif load.get_as_text() == "true":
			button.button_pressed = true
		load.close()
		
func set_option_setting(save_name, button):
	var load = FileAccess.open("user://" + save_name + ".yeet", FileAccess.READ)
	if load:
		button.selected = int(load.get_as_text())
		load.close()
	
func set_slider_setting(save_name, slider):
	var load = FileAccess.open("user://" + save_name + ".yeet", FileAccess.READ)
	if load:
		slider.value = float(load.get_as_text())
		load.close()
		
func save_setting(save_name: String, value):
	var save = FileAccess.open("user://" + save_name + ".yeet", FileAccess.WRITE)
	save.store_string(str(value))
	save.close()
	
func set_volumetrics(toggled): 
	save_setting("volumetrics", toggled)
	if environment != null: 
		environment.volumetric_fog_enabled = toggled
		
func set_glow(toggled):
	save_setting("glow", toggled)
	if environment != null:
		environment.glow_enabled = toggled 
		
func set_ssil(toggled):
	save_setting("ssil", toggled)
	if environment != null:
		environment.ssil_enabled = toggled
		
func set_vsync(toggled): 
	save_setting("vsync", toggled)
	if !toggled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	elif toggled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		
func set_fps_cap(index): 
	save_setting("fps", index)
	if index == 0: 
		Engine.max_fps = 30
	elif index == 1: 
		Engine.max_fps = 60
	elif index == 2: 
		Engine.max_fps = 0
		
func set_aa(index):
	save_setting("aa", index)
	if index == 0:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 1:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		get_viewport().use_taa = false
	elif index == 2:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = true
	elif index == 3:
		get_viewport().msaa_3d = Viewport.MSAA_2X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 4:
		get_viewport().msaa_3d = Viewport.MSAA_4X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 5:
		get_viewport().msaa_3d = Viewport.MSAA_8X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
		
func scale_3d(value):
	save_setting("3d_scaling", value)
	get_viewport().scaling_3d_scale = value
	
func set_master_volume(value): 
	save_setting("master_volume", value)
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func set_sfx_volume(value):
	save_setting("sfx_volume", value)
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func set_music_volume(value):
	save_setting("music_volume", value)
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func set_look_speed(value):
	save_setting("look_speed", value)
	if player_head != null:
		player_head.sensitivity = value 
	
func set_window_mode(index):
	save_setting("window_mode", index)
	if index == 0: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 2: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
func set_shadows(index): 
	save_setting("shadows", index)
	if index == 0:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
	elif index == 1:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
	elif index == 2:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
	elif index == 3:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
	elif index == 4:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
	elif index == 5:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
