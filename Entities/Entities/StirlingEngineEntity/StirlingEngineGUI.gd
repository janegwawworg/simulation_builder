extends BaseMachineGUI

var fuel: BlueprintEntity

onready var fuel_container := $HBoxContainer/InventaryBar
onready var fuel_bar := $HBoxContainer/ColorRect

func set_fuel(amount: float) -> void:
	if fuel_bar:
		fuel_bar.material.set_shader_param("fill_amount", amount)


func setup(gui: Control) -> void:
	fuel_container.setup(gui)


func update_labels() -> void:
	fuel_container.update_labels()


func _on_InventaryBar_inventory_changed(panel, held_item):
	fuel = held_item
	emit_signal("gui_status_changed")
