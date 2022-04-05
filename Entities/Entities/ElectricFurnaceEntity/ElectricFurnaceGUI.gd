extends FurnaceGUI


func update_speed(speed: float) -> void:
	if not is_inside_tree():
		return

	tween.playback_speed = speed


func setup(gui: Control) -> void:
	input_container.setup(gui)
	output_panel_container.setup(gui)
	output_panel = output_panel_container.panels[0]


func update_labels() -> void:
	input_container.update_labels()
	output_panel_container.update_labels()


func _find_nodes() -> void:
	input_container = $HBoxContainer/InputInventaryBar
