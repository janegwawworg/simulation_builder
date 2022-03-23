extends CenterContainer

var blueprint: BlueprintEntity setget _set_blueprint, _get_blueprint

onready var player_inventory := $HBoxContainer/InventoryWindow
onready var _drag_preview := $DragPreview


func _ready() -> void:
	player_inventory.setup(self)
	
	
func destory_blueprint() -> void:
	_drag_preview.destory_blueprint()
	
	
func update_label() -> void:
	_drag_preview.update_label()
	
	
func _set_blueprint(value: BlueprintEntity) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_drag_preview.blueprint = value
	
	
func _get_blueprint() -> BlueprintEntity:
	return _drag_preview.blueprint
