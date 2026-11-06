extends Control

var title_label: Label
var subtitle_label: Label
var body_label: Label
var clue_image: TextureRect

var recording_texture = preload("res://images/grabacion.png")
var map_texture = preload("res://images/mapa.png")
var document_texture = preload("res://images/documento.png")


func _ready() -> void:
	add_to_group("investigation_ui")
	hide()
	_build_document()

	if GameState.has_item("Documento secreto"):
		show_document()


func _build_document() -> void:
	var dark_background = ColorRect.new()
	dark_background.color = Color(0, 0, 0, 0.85)
	dark_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(dark_background)

	var document = PanelContainer.new()
	document.anchor_left = 0.12
	document.anchor_top = 0.07
	document.anchor_right = 0.88
	document.anchor_bottom = 0.93

	var paper_style = StyleBoxFlat.new()
	paper_style.bg_color = Color(0.88, 0.80, 0.64)
	paper_style.border_color = Color(0.35, 0.25, 0.16)
	paper_style.set_border_width_all(4)
	paper_style.set_corner_radius_all(6)

	document.add_theme_stylebox_override("panel", paper_style)
	add_child(document)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 35)
	margin.add_theme_constant_override("margin_right", 35)
	margin.add_theme_constant_override("margin_top", 25)
	margin.add_theme_constant_override("margin_bottom", 25)
	document.add_child(margin)

	# Contenedor principal: contenido desplazable + botón fijo
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(main_vbox)

	title_label = Label.new()
	title_label.text = "EXPEDIENTE 07"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_color_override("font_color", Color(0.25, 0.16, 0.09))
	title_label.add_theme_font_size_override("font_size", 30)
	main_vbox.add_child(title_label)

	subtitle_label = Label.new()
	subtitle_label.text = "LA DESAPARICIÓN"
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.add_theme_color_override("font_color", Color(0.35, 0.22, 0.12))
	subtitle_label.add_theme_font_size_override("font_size", 22)
	main_vbox.add_child(subtitle_label)

	main_vbox.add_child(HSeparator.new())

	# ✅ ScrollContainer para el texto largo
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(scroll)

	var content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 15)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(content)

	clue_image = TextureRect.new()
	clue_image.custom_minimum_size = Vector2(200, 150)
	clue_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	clue_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	clue_image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clue_image.hide()
	content.add_child(clue_image)

	body_label = Label.new()
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	body_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL  # ✅ CORREGIDO
	body_label.add_theme_color_override("font_color", Color(0.22, 0.15, 0.09))
	body_label.add_theme_font_size_override("font_size", 18)
	content.add_child(body_label)


	# ✅ Botón fijo abajo, SIEMPRE visible
	var close_button = Button.new()
	close_button.text = "CERRAR DOCUMENTO"
	close_button.custom_minimum_size.y = 45
	close_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(close_button)
	close_button.pressed.connect(_on_close_pressed)


func show_document() -> void:
	title_label.text = "EXPEDIENTE 07"
	subtitle_label.text = "LA DESAPARICIÓN"

	body_label.text = """Fecha: 17 de octubre de 1998

Si alguien encuentra este documento, significa que no pude terminar lo que empecé.

La joven no desapareció aquella noche. Alguien la mantuvo dentro de esta casa durante años, y las voces que se escuchan en los pasillos no son simples rumores.

Encontré fotografías, diarios y registros que demuestran que alguien de esta familia sabía lo que estaba ocurriendo.

Hay algo más que debes saber: la persona que dejó las pistas conoce tu nombre. Te ha estado esperando.

No confíes en la luz del sótano. Y, sobre todo, no respondas cuando escuches tu nombre.

— Una persona que intentó escapar"""

	clue_image.texture = document_texture
	clue_image.show()

	show()


func show_clue(clue_title: String, clue_description: String, texture: Texture2D) -> void:
	title_label.text = clue_title.to_upper()
	subtitle_label.text = "PISTA RECUPERADA"
	body_label.text = clue_description

	clue_image.texture = texture
	clue_image.visible = texture != null

	show()


func _on_close_pressed() -> void:
	hide()
