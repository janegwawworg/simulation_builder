extends CenterContainer

const QUICKBAR_ACTIONS := [
	"quickbar_1",
	"quickbar_2",
	"quickbar_3",
	"quickbar_4",
	"quickbar_5",
	"quickbar_6",
	"quickbar_7",
	"quickbar_8",
	"quickbar_9",
	"quickbar_0"
]

var blueprint: BlueprintEntity setget _set_blueprint, _get_blueprint
var mouse_in_gui := false

onready var player_inventory := $HBoxContainer/InventoryWindow
onready var _drag_preview := $DragPreview
onready var is_open: bool = $HBoxContainer/InventoryWindow.visible
onready var _gui_rect := $HBoxContainer
onready var _quickbar := $MarginContainer/QuickBar
onready var _quickbar_container := $MarginContainer


func _ready() -> void:
	player_inventory.setup(self)
	_quickbar.setup(self)
	
	
func _process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	mouse_in_gui = is_open and _gui_rect.get_rect().has_point(mouse_position)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if is_open:
			_close_inventories()
		else:
			_open_inventories()
	else:
		for i in QUICKBAR_ACTIONS.size():
			if InputMap.event_is_action(event, QUICKBAR_ACTIONS[i]) and event.is_pressed():
				_simulate_input(_quickbar.panels[i])
				break
				
				
func _simulate_input(panel: InventoryPanel) -> void:
	var input := InputEventMouseButton.new()
	input.button_index = BUTTON_LEFT
	input.pressed = true
	
	panel._gui_input(input)
			
			
func _close_inventories() -> void:
	is_open = false
	player_inventory.visible = false
	_claim_quickbar()
	
	
func _open_inventories() -> void:
	is_open = true
	player_inventory.visible = true
	player_inventory.claim_quickbar(_quickbar)
	
	
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


func _claim_quickbar() -> void:
	_quickbar.get_parent().remove_child(_quickbar)
	_quickbar_container.add_child(_quickbar)
