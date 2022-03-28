extends Node
class_name BlueprintEntity

export var placeable := true
export var stack_size := 100
export (String, MULTILINE) var description := ""

var stack_count := 1

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


func display_as_inventory_icon() -> void:
	var panel_size: float = ProjectSettings.get_setting("game_gui/inventory_size")
	
	self.position = Vector2(panel_size * 0.5, panel_size * 0.75)
	self.scale = Vector2(panel_size / 100, panel_size / 100)
	self.modulate = Color.white
	
	if power_direction:
		power_direction.hide()
		
		
func display_as_world_entity() -> void:
	self.scale = Vector2.ONE
	self.position = Vector2.ZERO
	if power_direction:
		power_direction.show()
