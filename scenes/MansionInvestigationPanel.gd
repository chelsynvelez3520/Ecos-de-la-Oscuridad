
extends Control

@onready var clue_image: TextureRect = $ClueWindow/ClueImage
@onready var clue_title: Label = $ClueWindow/ClueTitle
@onready var clue_description: Label = $ClueWindow/ClueDescription
@onready var enter_button: Button = $ClueWindow/EnterButton
@onready var close_button: Button = $ClueWindow/CloseButton

var photo_clue: Node
var rusty_key: Node
var bedroom_door: Node
var pending_destination: String = ""

# Imágenes de las pistas de la mansión
var photo_texture = preload("res://images/fotografia.png")
var key_texture = preload("res://images/llave.png")

func _ready() -> void:
	hide()

	photo_clue = get_node_or_null("../../Interactable1")
	if photo_clue != null:
		photo_clue.message_requested.connect(_on_photo_message_requested)
	else:
		push_warning("No se encontró Interactable1.")

	rusty_key = get_node_or_null("../../Interactable2")
	if rusty_key != null:
		rusty_key.message_requested.connect(_on_key_message_requested)
	else:
		push_warning("No se encontró Interactable2.")

	bedroom_door = get_node_or_null("../../LockedDoor")
	if bedroom_door != null:
		bedroom_door.message_requested.connect(_on_door_message_requested)
		bedroom_door.door_requested.connect(_on_door_requested)
	else:
		push_warning("No se encontró LockedDoor.")

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


func _on_photo_message_requested(_message: String) -> void:
	show_clue(
		"FOTOGRAFÍA ANTIGUA",
		"La joven aparece junto a una persona cuyo rostro fue arrancado.",
		photo_texture
	)


func _on_key_message_requested(_message: String) -> void:
	show_clue(
		"LLAVE OXIDADA",
		"Has encontrado una pequeña llave con las iniciales E.O. Quizás abra alguna puerta de la mansión.",
		key_texture
	)


func _on_door_message_requested(_message: String) -> void:
	show_clue(
		"PUERTA DEL DORMITORIO",
		"La puerta está cerrada. La cerradura tiene unas iniciales grabadas: E.O. Necesitas la llave oxidada.",
		key_texture
	)

func _on_door_requested(destination_scene: String) -> void:
	pending_destination = destination_scene
	clue_title.text = "PUERTA DEL DORMITORIO"
	clue_description.text = "La llave encaja en la cerradura. La puerta se abre lentamente."
	clue_image.hide()
	close_button.hide()
	enter_button.show()
	show()


func _on_enter_button_pressed() -> void:
	if pending_destination.is_empty():
		return
	get_tree().change_scene_to_file(pending_destination)


func _on_close_button_pressed() -> void:
	pending_destination = ""
	hide()
