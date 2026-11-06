
extends Control

signal puzzle_solved

@onready var puzzle_title: Label = $PuzzleWindow/VBoxContainer/PuzzleTitle
@onready var puzzle_description: Label = $PuzzleWindow/VBoxContainer/PuzzleDescription

@onready var symbol_1: OptionButton = $PuzzleWindow/VBoxContainer/Symbol1
@onready var symbol_2: OptionButton = $PuzzleWindow/VBoxContainer/Symbol2
@onready var symbol_3: OptionButton = $PuzzleWindow/VBoxContainer/Symbol3
@onready var symbol_4: OptionButton = $PuzzleWindow/VBoxContainer/Symbol4

@onready var check_button: Button = $PuzzleWindow/VBoxContainer/CheckButton
@onready var result_label: Label = $PuzzleWindow/VBoxContainer/ResultLabel
@onready var close_button: Button = $PuzzleWindow/VBoxContainer/CloseButton

var correct_sequence: Array[String] = [
	"Luna",
	"Ojo",
	"Llave",
	"Cuervo"
]

var solved: bool = false


func _ready() -> void:
	hide()


	puzzle_title.text = "LA CAJA DE SÍMBOLOS"
	puzzle_description.text = "Ordena los cuatro símbolos para revelar el secreto."

	var symbols: Array[String] = [
		"Luna",
		"Ojo",
		"Llave",
		"Cuervo"
	]

	var options: Array[OptionButton] = [
		symbol_1,
		symbol_2,
		symbol_3,
		symbol_4
	]

	for option in options:
		option.clear()
		option.add_item("Selecciona un símbolo")

		for symbol in symbols:
			option.add_item(symbol)

	result_label.text = "La caja permanece cerrada."

	check_button.pressed.connect(_on_check_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)


func open_puzzle() -> void:
	if solved:
		result_label.text = "La caja ya está abierta."
	else:
		result_label.text = "Ordena los símbolos correctamente."

	show()


func _on_check_button_pressed() -> void:
	if solved:
		return

	var selected_sequence: Array[String] = [
		symbol_1.get_item_text(symbol_1.selected),
		symbol_2.get_item_text(symbol_2.selected),
		symbol_3.get_item_text(symbol_3.selected),
		symbol_4.get_item_text(symbol_4.selected)
	]

	if selected_sequence.has("Selecciona un símbolo"):
		result_label.text = "Debes seleccionar los cuatro símbolos."
		return

	if selected_sequence == correct_sequence:
		solved = true
		result_label.text = "¡La caja se ha abierto! Has encontrado un documento secreto."
		puzzle_solved.emit()
	else:
		result_label.text = "La combinación es incorrecta. Inténtalo de nuevo."


func _on_close_button_pressed() -> void:
	hide()
