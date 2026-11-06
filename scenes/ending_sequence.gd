
extends CanvasLayer

@export var ending_music: AudioStream
@export var voice_sound: AudioStream
@export var door_sound: AudioStream

var overlay: ColorRect
var story_label: Label
var credits_button: Button

var music_player: AudioStreamPlayer
var voice_player: AudioStreamPlayer
var door_player: AudioStreamPlayer


func _ready() -> void:
	_build_interface()
	_start_audio()
	_play_ending()


func _build_interface() -> void:
	var screen = Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(screen)

	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(overlay)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(center)

	var content = VBoxContainer.new()
	content.custom_minimum_size = Vector2(650, 350)
	content.add_theme_constant_override("separation", 30)
	center.add_child(content)

	var heading = Label.new()
	heading.text = "ECOS DE LA OSCURIDAD"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 34)
	heading.add_theme_color_override(
		"font_color",
		Color(0.85, 0.78, 0.68)
	)
	content.add_child(heading)

	story_label = Label.new()
	story_label.text = ""
	story_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	story_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	story_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	story_label.custom_minimum_size = Vector2(650, 180)
	story_label.add_theme_font_size_override("font_size", 23)
	story_label.add_theme_color_override(
		"font_color",
		Color(0.92, 0.88, 0.82)
	)
	content.add_child(story_label)

	credits_button = Button.new()
	credits_button.text = "VOLVER AL MENÚ PRINCIPAL"
	credits_button.custom_minimum_size = Vector2(300, 50)
	credits_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	credits_button.hide()
	content.add_child(credits_button)

	credits_button.pressed.connect(_return_to_menu)

	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	door_player = AudioStreamPlayer.new()
	add_child(door_player)

	voice_player = AudioStreamPlayer.new()
	add_child(voice_player)


func _start_audio() -> void:
	if ending_music:
		music_player.stream = ending_music
		music_player.volume_db = -18
		music_player.play()


func _play_ending() -> void:
	# Esperar antes de comenzar el desenlace.
	await get_tree().create_timer(3.0).timeout

	# Oscurecer la pantalla.
	var tween = create_tween()
	tween.tween_property(
		overlay,
		"color",
		Color(0, 0, 0, 0.90),
		3.0
	)
	await tween.finished

	# Primera revelación.
	await _show_message(
		"Ahora lo recuerdo...\nYo estuve aquí antes.",
		5.0
	)

	# Segunda revelación.
	await _show_message(
		"La joven desaparecida no era una desconocida.\nSu historia estaba unida a la mía.",
		6.0
	)

	# Tercera revelación.
	await _show_message(
		"Todas las pistas fueron dejadas para conducirme hasta esta casa.\nAlguien sabía que regresaría.",
		6.0
	)

	# La música desaparece lentamente.
	if music_player.playing:
		var music_fade = create_tween()
		music_fade.tween_property(
			music_player,
			"volume_db",
			-80.0,
			3.0
		)
		await music_fade.finished
		music_player.stop()

	# Silencio para generar tensión.
	await get_tree().create_timer(2.5).timeout

	# Crujido de la puerta.
	if door_sound:
		door_player.stream = door_sound
		door_player.volume_db = -8
		door_player.play()

		await get_tree().create_timer(1.5).timeout

	# Último susurro.
	if voice_sound:
		voice_player.stream = voice_sound
		voice_player.volume_db = -3
		voice_player.play()

	await _show_message(
		"Y entonces escuché mi propia voz...\n«No debiste regresar...»",
		6.0
	)

	# Créditos finales.
	await _show_credits()


func _show_message(message: String, duration: float) -> void:
	story_label.text = message
	story_label.modulate.a = 0

	var tween = create_tween()
	tween.tween_property(
		story_label,
		"modulate:a",
		1.0,
		1.5
	)
	await tween.finished

	await get_tree().create_timer(duration).timeout

	var fade = create_tween()
	fade.tween_property(
		story_label,
		"modulate:a",
		0.0,
		1.5
	)
	await fade.finished


func _show_credits() -> void:
	story_label.text = (
		"ECOS DE LA OSCURIDAD\n\n"
		+ "Una historia de misterio, miedo y secretos.\n\n"
		+ "Desarrollo: Proyecto universitario\n\n"
		+ "Gracias por jugar."
	)

	story_label.modulate.a = 0

	var tween = create_tween()
	tween.tween_property(
		story_label,
		"modulate:a",
		1.0,
		2.0
	)
	await tween.finished

	credits_button.show()


func _return_to_menu() -> void:
	get_tree().change_scene_to_file(
		"res://scenes/MainMenu.tscn"
	)
