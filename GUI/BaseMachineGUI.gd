extends MarginContainer
class_name BaseMachineGUI

signal gui_status_changed
signal gui_opened
signal gui_closed


func _enter_tree() -> void:
	call_deferred("emit_signal", "gui_opened")
	
	
func _exit_tree() -> void:
	call_deferred("emit_signal", "gui_closed")
	
	
func setup(_gui: Control) -> void:
	pass
