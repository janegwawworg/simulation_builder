extends HBoxContainer
class_name InventoryBar

export var InventoryPanelScene: PackedScene
export var slot_count := 10

signal inventory_changed(panel, held_item)

var panels := []


func setup(gui: Control) -> void:
	for panel in panels:
		panel.setup(gui)
		panel.connect("held_item_changed", self, "_on_Panel_held_item_changed")


func _ready() -> void:
	_make_panels()
	
	
func _make_panels() -> void:
	for _i in slot_count:
		var panel := InventoryPanelScene.instance()
		add_child(panel)
		panels.append(panel)


func _on_Panel_held_item_changed(panel: Control, held_item: BlueprintEntity) -> void:
	emit_signal("inventory_changed", panel, held_item)
