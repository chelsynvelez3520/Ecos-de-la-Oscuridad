
extends Area2D

@export var display_name: String = "Pista"
@export_multiline var description: String = "No hay nada que leer."
@export_enum("clue", "key", "door", "puzzle") var interaction_type: String = "clue"
@export var required_item: String = ""
@export_file("*.tscn") var destination_scene: String = ""

signal message_requested(message: String)
signal door_requested(destination_scene: String)
signal puzzle_requested

var already_used := false



func interact() -> void:
	print("INTERACTUANDO CON: ", display_name)
	print("TIPO: ", interaction_type)

	if interaction_type == "puzzle":
		puzzle_requested.emit()
		return

	if interaction_type == "door":
		print("DOCUMENTO REQUERIDO: ", required_item)
		print("INVENTARIO: ", GameState.inventory)

		if not required_item.is_empty() and not GameState.has_item(required_item):
			message_requested.emit("La puerta está cerrada. Necesitas: " + required_item)
			return

		if destination_scene.is_empty():
			message_requested.emit("No hay una salida conectada todavía.")
			return

		print("EMITIENDO SEÑAL DE PUERTA: ", destination_scene)
		door_requested.emit(destination_scene)
		return

	if interaction_type == "key":
		if not already_used:
			GameState.add_item(display_name)
			already_used = true
			print("INVENTARIO ACTUAL: ", GameState.inventory)
			message_requested.emit("Has recogido: " + display_name)
		else:
			message_requested.emit("Ya recogiste este objeto.")
		return

	GameState.add_clue(display_name)
	message_requested.emit(display_name + ": " + description)
