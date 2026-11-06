
extends Control

@onready var info_label: Label = $Menu/Info

func _ready() -> void:
	pass


func _on_new_game_pressed() -> void:
	GameState.new_game()
	get_tree().change_scene_to_file("res://scenes/Exterior.tscn")


func _on_instructions_pressed() -> void:
	info_label.text = "WASD o flechas: mover | E: investigar | F: linterna | ESC: menú"


func _on_exit_button_pressed() -> void:
	get_tree().quit()
