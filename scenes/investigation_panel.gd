
extends Control

@onready var clue_image: TextureRect = $ClueWindow/ClueImage
@onready var clue_title: Label = $ClueWindow/ClueTitle
@onready var clue_description: Label = $ClueWindow/ClueDescription
@onready var enter_button: Button = $ClueWindow/EnterButton
@onready var close_button: Button = $ClueWindow/CloseButton

var anonymous_letter: Node
var mansion_door: Node
var pending_destination: String = ""

# Imágenes de las pistas
var letter_texture: Texture2D = preload("res://images/Carta anónima en mansión encantada-2.png")
var key_texture = preload("res://images/llave.png")
var diary_texture = preload("res://images/diario.png")
var photo_texture = preload("res://images/fotografia.png")
var recording_texture = preload("res://images/grabacion.png")
var map_texture = preload("res://images/mapa.png")
var document_texture = preload("res://images/documento.png")


func _ready() -> void:
	hide()

	anonymous_letter = get_node_or_null("../../Interactable1")

	if anonymous_letter != null:
		anonymous_letter.connect(
			"message_requested",
			Callable(self, "_on_letter_message_requested")
		)
	else:
		push_warning("No se encontró Interactable1.")

	mansion_door = get_node_or_null("../../Interactable2")

	if mansion_door != null:
		mansion_door.connect(
			"door_requested",
			Callable(self, "_on_door_requested")
		)
	else:
		push_warning("No se encontró Interactable2.")

	enter_button.hide()

	if not enter_button.pressed.is_connected(_on_enter_button_pressed):
		enter_button.pressed.connect(_on_enter_button_pressed)

	if not close_button.pressed.is_connected(_on_close_button_pressed):
		close_button.pressed.connect(_on_close_button_pressed)


# Mostrar una pista con su imagen
func show_clue(title: String, description: String, texture: Texture2D) -> void:
	pending_destination = ""

	clue_title.text = title
	clue_description.text = description
	clue_image.texture = texture

	clue_image.show()
	close_button.show()
	enter_button.hide()

	show()


# Cuando investigamos la carta
func _on_letter_message_requested(_message: String) -> void:
	show_clue(
		"CARTA ANÓNIMA",
		"La tinta está corrida. Si escuchas tu nombre, no respondas.",
		letter_texture
	)


# Cuando investigamos la puerta
func _on_door_requested(destination_scene: String) -> void:
	pending_destination = destination_scene

	clue_title.text = "ENTRADA DE LA MANSIÓN"
	clue_description.text = "La puerta está entreabierta. El interior parece estar completamente oscuro."

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
