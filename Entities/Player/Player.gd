extends KinematicBody2D

export var move_speed := 200.0
onready var camera := $Position2D/Camera2D
onready var level := $"../.."


func _ready():
	camera.set_limit(MARGIN_LEFT, level.get_limit().left)
	camera.set_limit(MARGIN_TOP, level.get_limit().top)
	camera.set_limit(MARGIN_RIGHT, level.get_limit().right)
	camera.set_limit(MARGIN_BOTTOM, level.get_limit().bottom)


func _physics_process(delta: float) -> void:
	var _direction := _get_direction()
	move_and_slide(move_speed * _direction)
	
	
func _get_direction() -> Vector2:
	return Vector2(
		(Input.get_action_strength("right") - Input.get_action_strength("left")) * 2.0,
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()


func _on_PickupRadius_area_entered(area: Area2D) -> void:
	var parent: GroundItem = area.get_parent()
	if parent:
		Events.emit_signal("entered_picked_area", parent, self)
