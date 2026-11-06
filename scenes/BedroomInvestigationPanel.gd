
extends Control

@onready var clue_image: TextureRect = $ClueWindow/ClueImage
@onready var clue_title: Label = $ClueWindow/ClueTitle
@onready var clue_description: Label = $ClueWindow/ClueDescription
@onready var enter_button: Button = $ClueWindow/EnterButton
@onready var close_button: Button = $ClueWindow/CloseButton

var bedroom_clue_1: Node
var bedroom_clue_2: Node
var exit_door: Node
var pending_destination: String = ""

# Imágenes de las pistas del dormitorio
var diary_texture = preload("res://images/diario.png")
var photo_texture = preload("res://images/fotografia.png")


func _ready() -> void:
	hide()

	# Conectar diario personal
	bedroom_clue_1 = get_node_or_null("../../Interactable1")
	if bedroom_clue_1 != null:
		bedroom_clue_1.message_requested.connect(_on_diary_message_requested)
	else:
		push_warning("No se encontró Interactable1 en Bedroom.")

	# Conectar fotografía escondida
	bedroom_clue_2 = get_node_or_null("../../Interactable2")
	if bedroom_clue_2 != null:
		bedroom_clue_2.message_requested.connect(_on_photo_message_requested)
	else:
		push_warning("No se encontró Interactable2 en Bedroom.")

	# Conectar puerta de salida
	exit_door = get_node_or_null("../../ExitDoor")
	if exit_door != null:
		exit_door.door_requested.connect(_on_exit_door_requested)
	else:
		push_warning("No se encontró ExitDoor en Bedroom.")

	# Configurar botones
	enter_button.hide()
	enter_button.pressed.connect(_on_enter_button_pressed)


func show_clue(title: String, description: String, texture: Texture2D) -> void:
	pending_destination = ""
	clue_title.text = title
	clue_description.text = description
	clue_image.texture = texture

	clue_image.show()
	close_button.show()
	enter_button.hide()
	show()


# Diario personal
func _on_diary_message_requested(_message: String) -> void:
	show_clue(
		"DIARIO PERSONAL",
		"Las últimas páginas están arrancadas. En una de ellas se alcanza a leer: «Él sabe que descubrí su secreto. Ya no estoy segura en esta casa».",
		diary_texture
	)


# Fotografía escondida
func _on_photo_message_requested(_message: String) -> void:
	show_clue(
		"FOTOGRAFÍA ESCONDIDA",
		"En la fotografía aparece la joven junto a un hombre. Al reverso hay una frase escrita: «No confíes en quien dice querer protegerte».",
		photo_texture
	)


# Apertura de la puerta del sótano
func _on_exit_door_requested(destination_scene: String) -> void:
	pending_destination = destination_scene
	clue_title.text = "PUERTA DEL SÓTANO"
	clue_description.text = "La puerta se abre lentamente. Unas escaleras descienden hacia la oscuridad."
	clue_image.hide()
	close_button.hide()
	enter_button.show()
	show()


# Botón ENTRAR
func _on_enter_button_pressed() -> void:
	if pending_destination.is_empty():
		return

	get_tree().change_scene_to_file(pending_destination)


# Botón CERRAR
func _on_close_button_pressed() -> void:
	pending_destination = ""
	hide()
