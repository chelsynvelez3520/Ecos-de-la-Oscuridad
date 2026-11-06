
extends CharacterBody2D

@export var speed: float = 150.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flashlight: PointLight2D = $Flashlight

@onready var interaction_area = $InteractionArea


var facing := Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var investigation_ui = get_tree().get_first_node_in_group("investigation_ui")

	if investigation_ui != null and investigation_ui.visible:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		facing = direction

		if sprite.sprite_frames.has_animation("walk"):
			sprite.play("walk")

		sprite.flip_h = direction.x < 0 if abs(direction.x) > abs(direction.y) else sprite.flip_h

	else:
		if sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")


		
func try_interact() -> bool:
	if interaction_area == null:
		return false

	for area in interaction_area.get_overlapping_areas():
		if area.has_method("interact"):
			area.interact()
			return true

	return false
