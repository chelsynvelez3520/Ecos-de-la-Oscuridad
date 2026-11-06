extends Node

var inventory: Array[String] = []
var clues_found: Array[String] = []
var current_scene_index: int = 0
var flashlight_on: bool = true

func new_game() -> void:
	inventory.clear()
	clues_found.clear()
	current_scene_index = 0
	flashlight_on = true

func add_item(item_name: String) -> void:
	if not inventory.has(item_name):
		inventory.append(item_name)
		print("INVENTARIO: ", inventory)

func add_clue(clue_id: String) -> void:
	if not clues_found.has(clue_id):
		clues_found.append(clue_id)

func has_item(item_name: String) -> bool:
	return inventory.has(item_name)
