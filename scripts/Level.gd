
extends Node2D

@export var level_title: String = "El sótano"
@export_multiline var objective: String = "Explora el sótano y busca pistas."

var objective_label: Label
var title_label: Label
var flashlight_label: Label
var flashlight: PointLight2D
var player: CharacterBody2D

var puzzle_box: Node
var puzzle_panel: Node
var exit_door: Node
var document_panel: Control

var recording_texture = preload("res://images/grabacion.png")
var map_texture = preload("res://images/mapa.png")


func _ready() -> void:
	objective_label = find_child("Objective", true, false) as Label
	title_label = find_child("Title", true, false) as Label
	flashlight_label = find_child("FlashlightStatus", true, false) as Label
	flashlight = find_child("Flashlight", true, false) as PointLight2D
	player = find_child("Player", true, false) as CharacterBody2D

	# Buscar el panel de documentos de Investigation.
	document_panel = find_child("DocumentPanel", true, false) as Control

	# Buscar los elementos del acertijo del sótano.
	puzzle_box = find_child("Interactable1", true, false)
	puzzle_panel = find_child("BasementPuzzlePanel", true, false)

	# Buscar la puerta de salida.
	# En Investigation se llama ExitDoor.
	# En Basement se llama Interactable2.
	exit_door = find_child("ExitDoor", true, false)

	if exit_door == null:
		exit_door = find_child("Interactable2", true, false)

	# Conectar la puerta.
	if exit_door and exit_door.has_signal("door_requested"):
		if not exit_door.door_requested.is_connected(_on_door_requested):
			exit_door.door_requested.connect(_on_door_requested)
			print("¡PUERTA DE SALIDA CONECTADA!")

	# Actualizar los textos del HUD.
	if objective_label:
		objective_label.text = objective

	if title_label:
		title_label.text = level_title

	_update_flashlight()

	# Conectar los mensajes de los objetos interactivos.
	for item in get_tree().get_nodes_in_group("interactables"):
		if item.has_signal("message_requested"):
			if not item.message_requested.is_connected(_show_message):
				item.message_requested.connect(_show_message)

	# Conectar las pistas de la sala de investigación
	# con el panel de documentos.
	if document_panel:
		var recording = find_child("Interactable1", true, false)
		var house_plan = find_child("Interactable2", true, false)

		for item in [recording, house_plan]:
			if item and item.has_signal("message_requested"):
				if item.get("interaction_type") == "clue":
					var callback = Callable(
						self,
						"_on_investigation_clue_requested"
					).bind(
						item.get("display_name"),
						item.get("description")
					)

					if not item.message_requested.is_connected(callback):
						item.message_requested.connect(callback)

					print("PISTA CONECTADA: ", item.get("display_name"))

	# Conectar el acertijo únicamente cuando sus nodos existen.
	if puzzle_box and puzzle_panel:
		if puzzle_box.has_signal("puzzle_requested"):
			if not puzzle_box.puzzle_requested.is_connected(puzzle_panel.open_puzzle):
				puzzle_box.puzzle_requested.connect(puzzle_panel.open_puzzle)

		if puzzle_panel.has_signal("puzzle_solved"):
			if not puzzle_panel.puzzle_solved.is_connected(_on_puzzle_solved):
				puzzle_panel.puzzle_solved.connect(_on_puzzle_solved)

		print("¡CAJA Y PANEL CONECTADOS!")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		GameState.flashlight_on = not GameState.flashlight_on
		_update_flashlight()

	elif event.is_action_pressed("interact"):
		if player and not player.try_interact():
			_show_message("Acércate a un objeto para investigarlo.")

	elif event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _update_flashlight() -> void:
	if flashlight:
		flashlight.enabled = GameState.flashlight_on

	if flashlight_label:
		flashlight_label.text = "Linterna: " + ("ENCENDIDA" if GameState.flashlight_on else "APAGADA") + " [F]"


func _show_message(message: String) -> void:
	if objective_label:
		objective_label.text = message


# Mostrar una pista en el panel grande de documentos.
func _on_investigation_clue_requested(
	_message: String,
	clue_title: String,
	clue_description: String
) -> void:

	var clue_texture: Texture2D = null
	var title_lower = clue_title.to_lower()

	if "grab" in title_lower:
		clue_texture = recording_texture

	elif "plano" in title_lower or "mapa" in title_lower:
		clue_texture = map_texture

	if document_panel and document_panel.has_method("show_clue"):
		document_panel.show_clue(
			clue_title,
			clue_description,
			clue_texture
		)


# Entregar el documento secreto al resolver el acertijo.
func _on_puzzle_solved() -> void:
	if not GameState.has_item("Documento secreto"):
		GameState.add_item("Documento secreto")
		GameState.add_clue("Documento secreto")

	# Desactivar la caja para que no siga interceptando E.
	if puzzle_box is Area2D:
		puzzle_box.set_deferred("monitorable", false)

	_show_message("Has encontrado el documento secreto. La puerta de salida está desbloqueada.")

	print("DOCUMENTO OBTENIDO: ", GameState.inventory)


# Cambiar de escena al utilizar una puerta.
func _on_door_requested(destination_scene: String) -> void:
	print("¡SE HA ACTIVADO LA PUERTA!")
	print("DESTINO: ", destination_scene)

	if destination_scene.is_empty():
		print("ERROR: DESTINO VACÍO")
		return

	get_tree().change_scene_to_file(destination_scene)

	
