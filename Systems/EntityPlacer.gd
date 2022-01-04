extends TileMap

var MAX_WORK_DISTANCE := 275.0
var POSITION_OFFSET := Vector2(0, 25)

var _blueprint: BlueprintEntity
var _tracker: EntityTracker
var _ground: TileMap
var _player: KinematicBody2D

onready var Libraby := {
	"StirlingEngine": preload("res://Entities/Blueprints/StirlingEngineBlueprint.tscn")
}


func _ready() -> void:
	Libraby[Libraby.StirlingEngine] = preload("res://Entities/Entities/StirlingEngine/StirlingEngine.tscn")
	
	
func _unhandled_input(event: InputEvent) -> void:
	var global_mouse_position := get_global_mouse_position()
	var has_placeable_blueprint := _blueprint and _blueprint.placeable
	var is_closer_to_player := global_mouse_position.distance_to(_player.global_position) < MAX_WORK_DISTANCE
	var cell := world_to_map(global_mouse_position)
	var cell_is_occpied := _tracker.is_cell_occupied(cell)
	var is_on_ground := _ground.get_cellv(cell) == 0
	
	if event.is_action_pressed("left_click"):
		if has_placeable_blueprint:
			if not cell_is_occpied and is_closer_to_player and is_on_ground:
				_place_entity(cell)
				
	elif event is InputEventMouseMotion:
		if has_placeable_blueprint:
			_move_blueprint_in_world(cell)
			
			
	elif event.is_action_pressed("drop") and _blueprint:
		remove_child(_blueprint)
		_blueprint = null
		
	elif event.is_action_pressed("quickbar_1"):
		if _blueprint:
			remove_child(_blueprint)
		_blueprint = Libraby.StirlingEngine
		add_child(_blueprint)
		_move_blueprint_in_world(cell)


func _process(delta: float) -> void:
	var has_placeable_blueprint := _blueprint and _blueprint.placeable
	if has_placeable_blueprint:
		_move_blueprint_in_world(world_to_map(get_global_mouse_position()))


func _exit_tree() -> void:
	Libraby.StirlingEngine.queue_free()
	
	
func setup(tracker: EntityTracker, ground: TileMap, player: KinematicBody2D) -> void:
	_tracker = tracker
	_ground = ground
	_player = player
	
	for child in get_children():
		if child is Entity:
			var map_position := world_to_map(child.global_position)
			_tracker.entity_placed(child, map_position)


func get_global_mouse_position() -> Vector2:
	return Vector2.ONE


func _place_entity(cell: Vector2) -> void:
	var new_entity: Node2D = Libraby[_blueprint].instance()
	add_child(new_entity)
	new_entity.global_position = map_to_world(cell) + POSITION_OFFSET
	new_entity.setup(_blueprint)
	_tracker.entity_placed(new_entity, cell)

func _move_blueprint_in_world(cell: Vector2) -> void:
	_blueprint.global_position = map_to_world(cell) + POSITION_OFFSET
	var is_closer_to_player := get_global_mouse_position().distance_to(_player.global_position) < MAX_WORK_DISTANCE
	var is_on_ground: bool = _ground.get_cellv(cell)
	var is_cell_occupied := _tracker.is_cell_occupied(cell)
	
	if not is_cell_occupied and is_closer_to_player and is_on_ground:
		_blueprint.modulate = Color.white
	else:
		_blueprint.modulate = Color.red
