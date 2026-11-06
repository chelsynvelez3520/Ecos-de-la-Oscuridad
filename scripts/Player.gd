extends CharacterBody2D

@export var speed: float = 155.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea

var facing := "down"

func _physics_process(_delta: float) -> void:
    var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * speed
    move_and_slide()

    if direction.length() > 0.05:
        if abs(direction.x) > abs(direction.y):
            facing = "right" if direction.x > 0 else "left"
        else:
            facing = "down" if direction.y > 0 else "up"
        sprite.play("walk")
        # The supplied sprite reference is arranged by action, with directional columns.
        # Flip the front-facing frame for left/right until dedicated directional clips are added.
        sprite.frame = 0 if facing in ["down", "right"] else 1
        if facing == "left":
            sprite.flip_h = true
        else:
            sprite.flip_h = false
    else:
        sprite.play("idle")
        sprite.frame = 0 if facing in ["down", "right"] else 1
        sprite.flip_h = facing == "left"

func try_interact() -> bool:
    for area in interaction_area.get_overlapping_areas():
        if area.has_method("interact"):
            area.interact()
            return true
    return false
