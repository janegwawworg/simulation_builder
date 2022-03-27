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

export var debug_items := {}

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
	Events.connect("entered_picked_area", self, "_on_Player_entered_pickup_area")
	
	for item in debug_items.keys():
		if not Library.blueprints.has(item):
			continue
			
		var item_instance: Node = Library.blueprints[item].instance()
		item_instance.stack_count = min(item_instance.stack_size, debug_items[item])
		
		if not add_to_inventory(item_instance):
			item_instance.queue_free()
	
	
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


func find_panels_with(item_id: String) -> Array:
	var existing_stacks: Array = (
		_quickbar.find_panels_with(item_id) +
		player_inventory.find_panels_with(item_id)
	)
	
	return existing_stacks


func add_to_inventory(item: BlueprintEntity) -> bool:
	if item && item.get_parent() != null:
		item.get_parent().remove_child(item)
		
	if _quickbar.add_to_first_available_inventory(item):
		return true
		
	return player_inventory.add_to_first_available_inventory(item)
	
	
func _on_Player_entered_pickup_area(item: GroundItem, player: KinematicBody2D) -> void:
	if not (item and item.blueprint):
		return
		
	var amount := 1
	if is_instance_valid(item.blueprint):
		amount = item.blueprint.stack_count
	
	if add_to_inventory(item.blueprint):
		item.do_pickup(player)
	else:
		if item.blueprint.stack_count < amount:
			var new_item := item.duplicate()
			
			item.get_parent().call_deferred("add_child", new_item)
			new_item.call_deferred("setup", item.blueprint)
			new_item.call_deferred("do_pickup", player)
