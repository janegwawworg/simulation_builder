extends BaseMachineGUI
class_name FurnaceGUI

var input: BlueprintEntity
var fuel: BlueprintEntity
var output_panel: Panel

var input_container: InventoryBar
var fuel_container: InventoryBar
var fuel_bar: ColorRect

onready var output_panel_container := $HBoxContainer/OutputInventaryBar
onready var tween :=$Tween
onready var arrow := $HBoxContainer/GUISprite


func _ready() -> void:
	var scale: float = (
		ProjectSettings.get_setting("game_gui/inventory_size") / arrow.region_rect.size.x
	)
	arrow.scale = Vector2(scale, scale)
	
	_find_nodes()


func _find_nodes() -> void:
	input_container = $HBoxContainer/VBoxContainer/InputInventaryBar
	fuel_container = $HBoxContainer/VBoxContainer/HBoxContainer/FuelInventaryBar
	fuel_bar = $HBoxContainer/VBoxContainer/HBoxContainer/ColorRect

func work(time: float) -> void:
	if not is_inside_tree():
		return

	tween.interpolate_method(self, "_advance_work_time", 0, 1, time)
	tween.start()


func abort() -> void:
	tween.stop_all()
	tween.remove_all()
	arrow.material.set_shader_param("fill_amount", 0)


func set_fuel(amount: float) -> void:
	if fuel_bar:
		fuel_bar.material.set_shader_param("fill_amount", amount)


func seek(time: float) -> void:
	if tween.is_active():
		tween.seek(time)


func setup(gui: Control) -> void:
	input_container.setup(gui)
	fuel_container.setup(gui)
	output_panel_container.setup(gui)
	output_panel = output_panel_container.panels[0]


func grab_output(item: BlueprintEntity) -> void:
	if not output_panel.held_item:
		output_panel.held_item = item
	else:
		var held_item_id := Library.get_entity_name_from(output_panel.held_item)
		var item_id := Library.get_entity_name_from(item)
		if held_item_id == item_id:
			output_panel.held_item.stack_count += item.stack_count
			
		item.queue_free()
	output_panel_container.update_labels()


func update_labels() -> void:
	input_container.update_labels()
	fuel_container.update_labels()
	output_panel_container.update_labels()


func _advance_work_time(amount: float) -> void:
	arrow.material.set_shader_param("fill_amount", amount)


func _on_InputInventaryBar_inventory_changed(panel, held_item) -> void:
	input = held_item
	emit_signal("gui_status_changed")


func _on_FuelInventaryBar_inventory_changed(panel, held_item) -> void:
	fuel = held_item
	emit_signal("gui_status_changed")
