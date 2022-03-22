extends HBoxContainer
class_name InventoryBar

export var InventoryPanelScene: PackedScene

export var slot_count := 10

var panels := []

func _ready() -> void:
	_make_panels()
	
	
func _make_panels() -> void:
	for _i in slot_count:
		var panel := InventoryPanelScene.instance()
		add_child(panel)
		panels.append(panel)
