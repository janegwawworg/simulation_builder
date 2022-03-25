extends CenterContainer

var blueprint: BlueprintEntity setget _set_blueprint, _get_blueprint
var mouse_in_gui := false

onready var player_inventory := $HBoxContainer/InventoryWindow
onready var _drag_preview := $DragPreview
onready var is_open: bool = $HBoxContainer/InventoryWindow.visible
onready var _gui_rect := $HBoxContainer


func _ready() -> void:
	player_inventory.setup(self)
	
	
func _process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	mouse_in_gui = is_open and _gui_rect.get_rect().has_point(mouse_position)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if is_open:
			_close_inventories()
		else:
			_open_inventories()
			
			
func _close_inventories() -> void:
	is_open = false
	player_inventory.visible = false
	
	
func _open_inventories() -> void:
	is_open = true
	player_inventory.visible = true
	
	
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
