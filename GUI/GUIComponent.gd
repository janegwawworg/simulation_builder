extends Node
class_name GUIComponent

signal gui_status_changed
signal gui_opened
signal gui_closed

var gui: BaseMachineGUI

export var GuiWindow: PackedScene


func _ready() -> void:
	assert(GuiWindow, "You must assign a scene to the the Gui Window property.")
	gui = GuiWindow.instance()
	
	gui.connect("gui_status_changed", self, "emit_signal", ["gui_status_changed"])
	gui.connect("gui_opened", self, "emit_signal", ["gui_opened"])
	gui.connect("gui_closed", self, "emit_signal", ["gui_closed"])
	
	
func _exit_tree() -> void:
	if gui:
		gui.queue_free()


func get_inventory_bars() -> Array:
	var output := []
	var parent_stack := [gui]
	
	while not parent_stack.empty():
		var current: Node = parent_stack.pop_back()
		if current is InventoryBar:
			output.push_back(current)
		parent_stack += current.get_children()
	
	return output
