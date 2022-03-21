extends Node
class_name BlueprintEntity

export var placeable := true

onready var power_direction := find_node("PowerDirection")


func rotate_blueprint() -> void:
	if not power_direction:
		return
		
	var directions: int = power_direction.output_directions
	var new_directions := 0
	
	if directions & Types.Direction.LEFT != 0:
		new_directions |= Types.Direction.UP
		
	if directions & Types.Direction.UP != 0:
		new_directions |= Types.Direction.RIGHT
		
	if directions & Types.Direction.RIGHT != 0:
		new_directions |= Types.Direction.DOWN
		
	if directions & Types.Direction.DOWN != 0:
		new_directions |= Types.Direction.LEFT
		
	power_direction.output_directions = new_directions
