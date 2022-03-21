extends TileMap

var MAX_WORK_DISTANCE := 275.0
var POSITION_OFFSET := Vector2(0, 25)
var DESCONSTRUCT_TIME := 0.3

var _blueprint: BlueprintEntity
var _tracker: EntityTracker
var _ground: TileMap
var _player: KinematicBody2D
var _current_desconstruct_position := Vector2.ZERO
var _flat_entities: Node2D

onready var _desconstruct_timer := $Timer
onready var Libraby := {
	"StirlingEngine": preload(
		"res://Entities/Blueprints/StirlingEngineBlueprint.tscn").instance(),
	"Wire": preload("res://Entities/Blueprints/WireBlueprint.tscn").instance(),
	"Battery": preload("res://Entities/Blueprints/BatteryBlueprint.tscn").instance(),
}


func _ready() -> void:
	Libraby[Libraby.StirlingEngine] = preload(
		"res://Entities/Entities/StirlingEngine/StirlingEngine.tscn")
	Libraby[Libraby.Wire] = preload("res://Entities/Entities/WireEntity/WireEntity.tscn")
	Libraby[Libraby.Battery] = preload("res://Entities/Entities/BatteryEntity/BatteryEntity.tscn")
	
	
func _unhandled_input(event: InputEvent) -> void:
	var global_mouse_pos := get_global_mouse_position()
	
	var has_placeable_blueprint: bool = _blueprint and _blueprint.placeable
	var is_closer_to_player := (
		global_mouse_pos.distance_to(_player.global_position) 
		< MAX_WORK_DISTANCE)
		
	var cell := world_to_map(global_mouse_pos)
	var cell_is_occpied := _tracker.is_cell_occupied(cell)
	var is_on_ground := _ground.get_cellv(cell) == 0
	
	if event is InputEventMouseButton:
		_abort_descontruct()
	
	if event.is_action_pressed("left_click"):
		if has_placeable_blueprint:
			if not cell_is_occpied and is_closer_to_player and is_on_ground:
				_place_entity(cell)
				_update_neighboring_flat_entities(cell)
		
	elif event.is_action_pressed("right_click") and not has_placeable_blueprint:
		if cell_is_occpied and is_closer_to_player:
			_descontruct(global_mouse_pos, cell)
				
	elif event is InputEventMouseMotion:
		if has_placeable_blueprint:
			_move_blueprint_in_world(cell)
		if cell != _current_desconstruct_position:
			_abort_descontruct()
			
	elif event.is_action_pressed("drop") and _blueprint:
		remove_child(_blueprint)
		_blueprint = null
		
	elif event.is_action_pressed("rotate_blueprint") and _blueprint:
		_blueprint.rotate_blueprint()
		
	elif event.is_action_pressed("quickbar_1"):
		if _blueprint:
			remove_child(_blueprint)
		_blueprint = Libraby.StirlingEngine
		add_child(_blueprint)
		_move_blueprint_in_world(cell)
		
	elif event.is_action_pressed("quickbar_2"):
		if _blueprint:
			remove_child(_blueprint)
		_blueprint = Libraby.Wire
		add_child(_blueprint)
		_move_blueprint_in_world(cell)
		
	elif event.is_action_pressed("quickbar_3"):
		if _blueprint:
			remove_child(_blueprint)
		_blueprint = Libraby.Battery
		add_child(_blueprint)
		_move_blueprint_in_world(cell)


func _process(delta: float) -> void:
	var has_placeable_blueprint: bool = _blueprint and _blueprint.placeable
	if has_placeable_blueprint:
		_move_blueprint_in_world(world_to_map(get_global_mouse_position()))


func _exit_tree() -> void:
	Libraby.StirlingEngine.queue_free()
	Libraby.Wire.queue_free()
	Libraby.Battery.queue_free()
	
	
func setup(
	tracker: EntityTracker, 
	ground: TileMap, 
	flat_entities: YSort, 
	player: KinematicBody2D
) -> void:
	_tracker = tracker
	_ground = ground
	_player = player
	_flat_entities = flat_entities
	
	for child in get_children():
		if child is Entity:
			var map_position := world_to_map(child.global_position)
			_tracker.entity_placed(child, map_position)


func _place_entity(cell: Vector2) -> void:
	var new_entity: Node2D = Libraby[_blueprint].instance()
	
	if _blueprint is WireBlueprint:
		var direction := _get_powered_neighbors(cell)
		_flat_entities.add_child(new_entity)
		WireBlueprint.set_sprite_for_direction(new_entity.sprite, direction)
	else:
		add_child(new_entity)
		
	new_entity.global_position = map_to_world(cell) + POSITION_OFFSET
	new_entity.setup(_blueprint)
	_tracker.entity_placed(new_entity, cell)


func _move_blueprint_in_world(cell: Vector2) -> void:
	_blueprint.global_position = map_to_world(cell) + POSITION_OFFSET
	
	var is_closer_to_player := (
		get_global_mouse_position().distance_to(_player.global_position) 
		< MAX_WORK_DISTANCE)
	var is_on_ground: bool = _ground.get_cellv(cell) == 0
	var is_cell_occupied := _tracker.is_cell_occupied(cell)
	
	if not is_cell_occupied and is_closer_to_player and is_on_ground:
		_blueprint.modulate = Color.white
	else:
		_blueprint.modulate = Color.red
		
	if _blueprint is WireBlueprint:
		WireBlueprint.set_sprite_for_direction(_blueprint.sprite,
_get_powered_neighbors(cell))


func _descontruct(mouse: Vector2, cell: Vector2) -> void:
	_desconstruct_timer.connect(
		"timeout", self, "_finish_descontruct", [cell], CONNECT_ONESHOT)
		
	_desconstruct_timer.start(DESCONSTRUCT_TIME)
	_current_desconstruct_position = cell


func _finish_descontruct(cell: Vector2) -> void:
	var entity := _tracker.get_entity(cell)
	_tracker.entity_remove(cell)
	_update_neighboring_flat_entities(cell)


func _abort_descontruct() -> void:
	if _desconstruct_timer.is_connected("timeout", self, "_finish_descontruct"):
		_desconstruct_timer.disconnect("timeout", self, "_finish_descontruct")
	_desconstruct_timer.stop()

func _get_powered_neighbors(cell: Vector2) -> int:
	var direction := 0
	
	for neighbor in Types.NEIGHBORS.keys():
		var key: Vector2 = cell + Types.NEIGHBORS[neighbor]
		
		if _tracker.is_cell_occupied(key):
			var entity: Node = _tracker.get_entity(key)
			
			if (
				entity.is_in_group(Types.POWER_MOVERS)
				or entity.is_in_group(Types.POWER_RECEIVERS)
				or entity.is_in_group(Types.POWER_SOURCES)
			):
				direction |= neighbor
	return direction


func _update_neighboring_flat_entities(cell: Vector2) -> void:
	for neighbor in Types.NEIGHBORS.keys():
		var key: Vector2 = cell + Types.NEIGHBORS[neighbor]
		var object = _tracker.get_entity(key)
		
		if object and object is WireEntity:
			var tile_directions := _get_powered_neighbors(key)
			WireBlueprint.set_sprite_for_direction(object.sprite, tile_directions)
